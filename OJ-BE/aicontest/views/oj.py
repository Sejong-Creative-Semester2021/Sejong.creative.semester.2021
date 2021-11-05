import random
from django.db.models import Q, Count
from utils.api import APIView, CSRFExemptAPIView
from account.decorators import check_contest_permission
from ..models import AIProblemTag, AIProblem, AIProblemRuleType
from ..serializers import ProblemSerializer, TagSerializer, ProblemSafeSerializer, FileUploadForm
from contest.models import ContestRuleType

from django.conf import settings
from utils.shortcuts import rand_str, natural_sort_key
import os
import json
import csv
# import pandas as pd test
import numpy as np

import logging
logger=logging.getLogger(__name__)

class ProblemTagAPI(APIView):
    def get(self, request):
        qs = AIProblemTag.objects
        keyword = request.GET.get("keyword")
        if keyword:
            qs = AIProblemTag.objects.filter(name__icontains=keyword)
        tags = qs.annotate(problem_count=Count("problem")).filter(problem_count__gt=0)
        return self.success(TagSerializer(tags, many=True).data)


class PickOneAPI(APIView):
    def get(self, request):
        problems = AIProblem.objects.filter(contest_id__isnull=True, visible=True)
        count = problems.count()
        if count == 0:
            return self.error("No problem to pick")
        return self.success(problems[random.randint(0, count - 1)]._id)


class ProblemAPI(APIView):
    @staticmethod
    def _add_problem_status(request, queryset_values):
        if request.user.is_authenticated:
            profile = request.user.userprofile
            acm_problems_status = profile.acm_problems_status.get("problems", {})
            oi_problems_status = profile.oi_problems_status.get("problems", {})
            # paginate data
            results = queryset_values.get("results")
            if results is not None:
                problems = results
            else:
                problems = [queryset_values, ]
            for problem in problems:
                if problem["rule_type"] == AIProblemRuleType.ACM:
                    problem["my_status"] = acm_problems_status.get(str(problem["id"]), {}).get("status")
                else:
                    problem["my_status"] = oi_problems_status.get(str(problem["id"]), {}).get("status")
    
    # def post(self, request):
    #     data = request.data
    #     _id = data["problemID"]
    #     csv_file = data["formdata"]
    #     logger.info("data={}".format(data))
    #     logger.info("data={}".format(data["problemID"]))
    #     logger.info("data={}".format(data["formdata"]))
    #     if not _id:
    #         return self.error("Display ID is required")

    #     error_info = self.common_checks(request)
    #     if error_info:
    #         return self.error(error_info)

    #     # todo check filename and score info
    #     problem = AIProblem.objects.create(**data)

    #     logger.info("data={}".format(problem))

    #     return self.success(ProblemSerializer(problem).data)
        
    def get(self, request):
        # 问题详情页
        logger.info('problem get oj inin')
        problem_id = request.GET.get("problem_id")
        logger.info('problem_id={}'.format(problem_id))
        if problem_id:
            try:
                problem = AIProblem.objects.select_related("created_by") \
                    .get(_id=problem_id, contest_id__isnull=True, visible=True)
                problem_data = ProblemSerializer(problem).data
                self._add_problem_status(request, problem_data)
                logger.info('problem={}'.format(problem))
                logger.info('problem_data={}'.format(problem_data))
                return self.success(problem_data)
            except AIProblem.DoesNotExist:
                return self.error("Problem does not exist")
        logger.info('problem get continue')
        limit = request.GET.get("limit")
        if not limit:
            return self.error("Limit is needed")

        problems = AIProblem.objects.select_related("created_by").filter(contest_id__isnull=True, visible=True)
        # 按照标签筛选
        tag_text = request.GET.get("tag")
        if tag_text:
            problems = problems.filter(tags__name=tag_text)

        # 搜索的情况
        keyword = request.GET.get("keyword", "").strip()
        if keyword:
            problems = problems.filter(Q(title__icontains=keyword) | Q(_id__icontains=keyword))

        # 难度筛选
        difficulty = request.GET.get("difficulty")
        if difficulty:
            problems = problems.filter(difficulty=difficulty)
        # 根据profile 为做过的题目添加标记
        data = self.paginate_data(request, problems, ProblemSerializer)
        self._add_problem_status(request, data)
        return self.success(data)


class ContestProblemAPI(APIView):
    def _add_problem_status(self, request, queryset_values):
        if request.user.is_authenticated:
            profile = request.user.userprofile
            if self.contest.rule_type == ContestRuleType.ACM:
                problems_status = profile.acm_problems_status.get("contest_problems", {})
            else:
                problems_status = profile.oi_problems_status.get("contest_problems", {})
            for problem in queryset_values:
                problem["my_status"] = problems_status.get(str(problem["id"]), {}).get("status")

    @check_contest_permission(check_type="problems")
    def get(self, request):
        problem_id = request.GET.get("problem_id")
        if problem_id:
            try:
                problem = AIProblem.objects.select_related("created_by").get(_id=problem_id,
                                                                           contest=self.contest,
                                                                           visible=True)
            except AIProblem.DoesNotExist:
                return self.error("Problem does not exist.")
            if self.contest.problem_details_permission(request.user):
                problem_data = ProblemSerializer(problem).data
                self._add_problem_status(request, [problem_data, ])
            else:
                problem_data = ProblemSafeSerializer(problem).data
            return self.success(problem_data)

        contest_problems = AIProblem.objects.select_related("created_by").filter(contest=self.contest, visible=True)
        if self.contest.problem_details_permission(request.user):
            data = ProblemSerializer(contest_problems, many=True).data
            self._add_problem_status(request, data)
        else:
            data = ProblemSafeSerializer(contest_problems, many=True).data
        return self.success(data)

class TestCaseZipProcessor(object):
    def process_csv(self, uploaded_csv_file, dir=""):
        logger.info("in_process_csv")
        predict_id = rand_str()
        predict_dir = os.path.join(settings.PREDICT_DIR, predict_id)
        os.makedirs(predict_dir)
        os.chmod(predict_dir, 0o710)
        logger.info("dif={}".format(predict_dir))

        with open(os.path.join(predict_dir, "predict.csv"), "w") as f:
            open_file=open(uploaded_csv_file, "r")
            logger.info("open_file={}".format(open_file))
            rr = csv.reader(open_file, delimiter=',')
            logger.info("rr={}".format(rr))
            wr = csv.writer(f)
            logger.info("wr={}".format(wr))
            wr.writerows(rr)
            
        # with open(os.path.join(predict_dir, "predict.csv"), "w") as f:
        #     f.write(uploaded_csv_file)

        os.chmod(os.path.join(predict_dir, uploaded_csv_file), 0o640)

        info = []

        return info, predict_id


class FileAPI(CSRFExemptAPIView, TestCaseZipProcessor):
    request_parsers = ()
    logger.info("inin")
    def post(self, request):
        logger.info("in_post")
        form = FileUploadForm(request.POST, request.FILES)
        logger.info("form={}".format(form))

        if form.is_valid():
            id = form.cleaned_data["id"] 
            file = form.cleaned_data["file"]
        else:
            return self.error("Upload failed")

        logger.info("file={}".format(file))
        tmp_file = f"/tmp/{rand_str()}.csv"
        logger.info("tmp_file={}".format(tmp_file))
        
        with open(tmp_file, "wb") as f:
            for chunk in file:
                # logger.info("chunk={}".format(chunk))
                f.write(chunk)
                
        info, predict_id = self.process_csv(tmp_file)

        logger.info("id={}".format(id))
        csv = AIProblem.objects.get(_id=id)
        
        logger.info("csv={}".format(csv))
        logger.info("csv={}".format(AIProblem.objects.values()))
        logger.info("solution_id={}".format(csv.solution_id))
        logger.info("os_sol={}".format(os.path.join(settings.SOLUTION_DIR, str(csv.solution_id), "solution.csv")))
        logger.info("os_pre={}".format(os.path.join(settings.PREDICT_DIR, predict_id, "predict.csv")))

        y_true = np.array(np.loadtxt(os.path.join(settings.SOLUTION_DIR, csv.solution_id, "solution.csv"), delimiter=",", dtype=np.float32))
        y_pred = np.array(np.loadtxt(os.path.join(settings.PREDICT_DIR, predict_id, "predict.csv"), delimiter=",", dtype=np.float32))
        logger.info("y_true={}".format(str(y_true)))
        logger.info("y_pred={}".format(str(y_pred)))

        y_score = (y_true == y_pred).mean()
        logger.info("y_score={}".format(str(y_score)))

        # y_true = np.array(pd.read_csv(os.path.join(settings.SOLUTION_DIR, csv.solution_id, "solution.csv")))
        # y_pred = np.array(pd.read_csv(os.path.join(settings.PREDICT_DIR, predict_id, "predict.csv")))
        
        # logger.info("y_true={}".format(y_true))
        # logger.info("y_pred={}".format(y_pred))

        # y_score = (y_true.astype(bool) == y_pred.astype(bool)).mean()
        # logger.info("y_score={}".format(y_score))
        
        os.remove(tmp_file)

        return self.success({"predictId": predict_id, "solutionId": csv.solution_id, "info": info, "y_score": y_score})
    

class AIRankAPI(APIView):
    def put(self, request):
        logger.info("AIRank inside put")
        # logger.info("request", request)
        # logger.info('request.data.rank={}'.format(request.data.rank))
        # logger.info('data={}'.format(data))
        # logger.info('request.data.pop("rank")={}'.format(data("rank"))) // error - TypeError: 'dict' object is not callable
        # logger.info('request.data["rank"]={}'.format(data["rank"]))
        # logger.info("request.data", request.data)

        data = request.data
        problem_id = data['problemID'] # 우리가 가져온 id - DisplayID

        try:
            problem = AIProblem.objects.get(_id=problem_id)
            logger.info('problem={}'.format(problem))
            # ensure_created_by(problem, request.user)
        except AIProblem.DoesNotExist:
            return self.error("Problem does not exist")

        # _id = data["_id"] # Display ID
        # if not _id:
        #     return self.error("Display ID is required")
        # if AIProblem.objects.exclude(id=problem_id).filter(_id=_id, contest_id__isnull=True).exists():
        #     return self.error("Display ID already exists")

        # error_info = self.common_checks(request)
        # if error_info:
        #     return self.error(error_info)
        # todo check filename and score info
        # tags = data.pop("tags")
        # data["languages"] = list(data["languages"])


        #rank = {'problemID': '211026 test', 'rank': [{'userid': 1, 'username': 'root', 'score': 10}, {'userid': 1, 'username': 'root', 'score': 10}]}


        old_rank_list = problem.rank

        if old_rank_list == None:
            old_rank_list = []

        same_person_flag = False
        logger.info("before old_rank_list={}".format(old_rank_list))
        for index, old_data in enumerate(old_rank_list):
            if data['rank'][0]['userid'] == old_data['userid']:
                same_person_flag = True
                if old_data['score'] < data['rank'][0]['score']:
                    del old_rank_list[index]
                    old_rank_list.append(data['rank'][0])
                    break
        logger.info("after old_rank_list={}".format(old_rank_list))
        if not same_person_flag:
            old_rank_list.append(data['rank'][0])
        logger.info("after2 old_rank_list={}".format(old_rank_list))

        # logger.info("data['rank'][0]={}".format(data['rank'][0]))
        # for i in old_rank_list:
            # user_id_set.add(i['userid'])
        # logger.info("user_id_set={}".format(user_id_set))
        # new_rank = [old_rank, data['rank'][0]]
        # else:
        #     if data['rank'][0]['userid'] not in user_id_set:
        #         old_rank_list.append(data['rank'][0])
        #     else:
        #         if data['rank'][0]['score'] < userid - maxscore:
        #             old_rank_list.append(data['rank'][0])
        # logger.info("old_rank_list_after_append={}".format(old_rank_list))
        # logger.info("data={}".format(data))
        # logger.info("data.items()={}".format(data.items()))
        # data['rank']['rank_list'] = ['bi','asdf','zxcv']
        # data['rank']['rank_list'] = []
        # for k, v in data.items():
        #     logger.info("k={}".format(k))
        #     logger.info("v={}".format(v))
            # data['rank']['rank_list'].append(v)
        # old_rank_list.sort(key=lambda x:x['score'], reverse=True)
        old_rank_list.sort(key=lambda x:(-x['score'], x['submitTime']))
        logger.info("after sort old_rank_list={}".format(old_rank_list))
        setattr(problem, 'rank', old_rank_list)
        # problem['rank'].sort(key = lambda x:x['y_score'])
        problem.save()
        logger.info("problem saved")
        # problem.tags.remove(*problem.tags.all())
        # for tag in tags:
        #     try:
        #         tag = AIProblemTag.objects.get(name=tag)
        #     except AIProblemTag.DoesNotExist:
        #         tag = AIProblemTag.objects.create(name=tag)
        #     problem.tags.add(tag)

        return self.success()
    
    def get(self, request):
        # data = request.date
        # problem_id = data['problemID']
        logger.info("AIRank get")
        problem_id = request.GET.get("problemID")
        logger.info("problemID={}".format(problem_id))
        rank = request.GET.get("rank")
        logger.info("rank={}".format(rank))
        problem = AIProblem.objects.get(_id=problem_id)
        logger.info("problem={}".format(problem))
        logger.info("problem.rank={}".format(problem.rank))
        return self.success(problem.rank)


    

