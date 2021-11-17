import random
from django.db.models import Q, Count
from utils.api import APIView, CSRFExemptAPIView, APIError
from account.decorators import check_contest_permission, ensure_created_by
from ..models import AIProblemTag, AIProblem, AIProblemRuleType
from ..serializers import ProblemSerializer, TagSerializer, ProblemSafeSerializer, FileUploadForm
from contest.models import ContestRuleType

from wsgiref.util import FileWrapper
from django.http import StreamingHttpResponse, FileResponse

from django.conf import settings
from utils.shortcuts import rand_str, natural_sort_key
import os
import json
import csv
# import pandas as pd
import numpy as np
# import sklearn

import logging
logger=logging.getLogger(__name__)

class ProblemTagAPI(APIView):
    def get(self, request):
        qs = AIProblemTag.objects
        keyword = request.GET.get("keyword")
        if keyword:
            qs = AIProblemTag.objects.filter(name__icontains=keyword)
        tags = qs.annotate(problem_count=Count("aiproblem")).filter(problem_count__gt=0)
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
            # paginate data
            results = queryset_values.get("results")
            if results is not None:
                problems = results
            else:
                problems = [queryset_values, ]
    
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
        # limit = request.GET.get("limit")
        # if not limit:
        #     return self.error("Limit is needed")

        problems = AIProblem.objects.select_related("created_by").filter(contest_id__isnull=True, visible=True)
        # 按照标签筛选
        tag_text = request.GET.get("tag")
        if tag_text:
            problems = problems.filter(tags__name=tag_text)

        # 搜索的情况
        keyword = request.GET.get("keyword", "").strip()
        if keyword:
            problems = problems.filter(Q(title__icontains=keyword))

        # 难度筛选
        # difficulty = request.GET.get("difficulty")
        # if difficulty:
        #     problems = problems.filter(difficulty=difficulty)
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
        """ csv format. both solution.csv, predict.csv
        index,col_name
        0,4
        1,65
        2,13
        3,346
        """
        y_true = np.array(np.loadtxt(os.path.join(settings.SOLUTION_DIR, csv.solution_id, "solution.csv"), delimiter=",", dtype=np.float32, skiprows=1, usecols = (1,)))
        y_pred = np.array(np.loadtxt(os.path.join(settings.PREDICT_DIR, predict_id, "predict.csv"), delimiter=",", dtype=np.float32, skiprows=1, usecols = (1,)))
        logger.info("y_true={}".format(str(y_true)))
        logger.info("y_pred={}".format(str(y_pred)))
        
        eval_type = csv.eval_type
        logger.info("eval_type={}".format(eval_type))

        if eval_type == 'mse':
            logger.info("if mse in")
            y_score = np.square(np.subtract(y_true, y_pred)).mean()
            logger.info("y_score={}".format(str(y_score)))

        if eval_type == 'acc':
            logger.info("if acc in")
            y_score = (y_true == y_pred).mean()
            logger.info("y_score={}".format(str(y_score)))

        if eval_type == 'rmse':
            logger.info("if rmse in")
            y_score = np.sqrt(np.mean(np.subtract(y_true, y_pred)**2))
        
        if eval_type == 'auc':
            logger.info("if auc in")

        if eval_type == 'mean_f_score':
            logger.info("if mean_f_score in")
            # accuracy = np.mean(np.equal(y_true, y_pred))
            right = np.sum(y_true * y_pred == 1)
            precision = right / np.sum(y_pred)
            recall = right / np.sum(y_true)
            f1 = 2 * precision*recall/(precision+recall)
            y_score = f1
            logger.info("if mean_f_score out")

        if eval_type == 'mae':
            logger.info("if mae in")
            y_score = np.mean(np.abs(np.subtract(y_true, y_pred)))

        if eval_type == 'f_beta':
            logger.info("if f_beta in")

        if eval_type == 'logloss':
            logger.info("if logloss in")
            def my_logloss(answer_array, proba_array):
                # 출처 https://velog.io/@skyepodium/logloss-%EC%95%8C%EC%95%84%EB%B3%B4%EA%B8%B0
                # 0이면 무한대 값이 나오기 때문에 0에 가까운 값으로 치환해줍니다.
                MIN_VALUE = 1e-15
                # array의 크기를 가져옵니다.
                size = answer_array.shape[0]
                # 반복문을 사용해서 logloss의 합을 계산합니다.
                logloss_sum = 0
                # zip함수로 묶으면 함께 순회할 수 있습니다.
                for answer, arr in zip(answer_array, proba_array):
                    proba = arr[answer - 1]
                    # 0이면 무한대 값이 나오기 때문에 0에 가까운 값으로 치환해줍니다.
                    if proba <= MIN_VALUE:
                        proba = MIN_VALUE
                    # 음의 로그함수에 넣어서 logloss 계산
                    logloss_sum += -np.log(proba)
                # logloss의 평균 계산
                result = logloss_sum / size
                # 반환
                return result
            y_score = my_logloss(y_true, y_pred)

        if eval_type == 'rmsle':
            logger.info("if rmsle in")
            def rmsle(predicted_values, actual_values):
                # 예측값과 실제 값에 1을 더하고 로그를 씌워준다.
                log_predict = np.log(predicted_values + 1)
                log_actual = np.log(actual_values + 1)
                # 위에서 계산한 예측값에서 실제값을 빼주고 제곱을 해준다.
                difference = log_predict - log_actual
                # difference = (log_predict - log_actual) ** 2
                difference = np.square(difference)
                # 평균을 낸다.
                mean_difference = difference.mean()
                # 다시 루트를 씌운다.
                score = np.sqrt(mean_difference)
                return score
            y_score = rmsle(y_true, y_pred)

        if eval_type == 'map@k':
            logger.info("if map@k in")
                
        os.remove(tmp_file)

        y_score = float(y_score)
        
        logger.info("float change - y_score={}".format(y_score))

        return self.success({"predictId": predict_id, "solutionId": csv.solution_id, "info": info, "y_score": y_score})


class DataFileAPI(CSRFExemptAPIView):
    request_parsers = ()
    logger.info("data_inin")

    def get(self, request):
        logger.info("user data_inin")
        problem_id = request.GET.get("problem_id")
        logger.info("user problem id={}".format(problem_id))
        if not problem_id:
            return self.error("Parameter error, problem_id is required")
        try:
            problem = AIProblem.objects.get(id=problem_id)
        except AIProblem.DoesNotExist:
            return self.error("Problem does not exists")
        logger.info("user problem={}".format(problem))
        logger.info("user problem.data id={}".format(problem.data_id))
        # if problem.contest:
        #     ensure_created_by(problem.contest, request.user)
        # else:
        #     ensure_created_by(problem, request.user)
        data_dir = os.path.join(settings.DATA_DIR, problem.data_id)
        logger.info("user data_dir={}".format(data_dir))
        if not os.path.isdir(data_dir):
            return self.error("Data does not exists")

        # name_list=os.listdir(data_dir)
        # logger.info("name_list={}".format(name_list))
        # zip_dir=os.path.join(settings.ZIP_DIR, problem.data_id)
        # os.makedirs(zip_dir)
        file_name = os.path.join(data_dir, problem.data_id + ".zip")
        logger.info("file_name={}".format(file_name))
        # with zipfile.ZipFile(file_name, "w") as file:
        #     for data in name_list:
        #         file.write(f"{data_dir}/{data}", data)
        response = StreamingHttpResponse(FileWrapper(open(file_name, "rb")),
                                         content_type="application/octet-stream")

        response["Content-Disposition"] = f"attachment; filename=problem_{problem.id}_data.zip"
        response["Content-Length"] = os.path.getsize(file_name)
        return response

class ProblemGeneralAPI(APIView):
    @staticmethod
    def _add_problem_status(request, queryset_values):
        if request.user.is_authenticated:
            profile = request.user.userprofile
            # paginate data
            results = queryset_values.get("results")
            if results is not None:
                problems = results
            else:
                problems = [queryset_values, ]
        
    def get(self, request):
        # 问题详情页
        problem_id = request.GET.get("problem_id")
        logger.info("g_problem_id={}".format(problem_id))
        if problem_id:
            problems = AIProblem.objects.select_related("created_by") \
                    .filter(_id=problem_id, contest_id__isnull=True, visible=True, p_type='General')
        else:
            problems = AIProblem.objects.select_related("created_by").filter(contest_id__isnull=True, visible=True, p_type='General')
        logger.info("g_problems={}".format(problems))
        # 按照标签筛选
        tag_text = request.GET.get("tag")
        if tag_text:
            problems = problems.filter(tags__name=tag_text)

        # 搜索的情况
        keyword = request.GET.get("keyword", "").strip()
        if keyword:
            problems = problems.filter(Q(title__icontains=keyword))

        # 根据profile 为做过的题目添加标记
        data = self.paginate_data(request, problems, ProblemSerializer)
        logger.info("g_data={}".format(data))
        self._add_problem_status(request, data)
        return self.success(data)

class ProblemClassAPI(APIView):
    @staticmethod
    def _add_problem_status(request, queryset_values):
        if request.user.is_authenticated:
            profile = request.user.userprofile
            # paginate data
            results = queryset_values.get("results")
            if results is not None:
                problems = results
            else:
                problems = [queryset_values, ]
        
    def get(self, request):
        # 问题详情页
        problem_id = request.GET.get("problem_id")
        if problem_id:
            problems = AIProblem.objects.select_related("created_by") \
                    .filter(_id=problem_id, contest_id__isnull=True, visible=True, p_type='Class')
        
        # limit = request.GET.get("limit")
        # if not limit:
        #     return self.error("Limit is needed")

        else:
            problems = AIProblem.objects.select_related("created_by").filter(contest_id__isnull=True, visible=True, p_type='Class')

        # 按照标签筛选
        tag_text = request.GET.get("tag")
        if tag_text:
            problems = problems.filter(tags__name=tag_text)

        # 搜索的情况
        keyword = request.GET.get("keyword", "").strip()
        if keyword:
            problems = problems.filter(Q(title__icontains=keyword))

        # # 难度筛选
        # difficulty = request.GET.get("difficulty")
        # if difficulty:
        #     problems = problems.filter(difficulty=difficulty)
        # 根据profile 为做过的题目添加标记
        data = self.paginate_data(request, problems, ProblemSerializer)
        self._add_problem_status(request, data)
        return self.success(data)
        
    

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
        
        sort_type = 0 
        # sort_type = 0 -> ascending
        # sort_type = 1 -> descending
        
        if problem.eval_type == 'acc':
            logger.info("eval_type acc")
            sort_type = 1
        if problem.eval_type == 'mean_f_score':
            logger.info("eval_type mean_f_score")
            sort_type = 1
            
        logger.info("sort_type={}".format(sort_type))
        old_rank_list = problem.rank

        if old_rank_list == None:
            old_rank_list = []
########################changed this part descending#################################
        if sort_type == 1:
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
            old_rank_list.sort(key=lambda x:(-x['score'], x['submitTime']))
            logger.info("after sort old_rank_list={}".format(old_rank_list))
############################to this ascending#############################
        else:
            same_person_flag = False
            logger.info("before old_rank_list={}".format(old_rank_list))
            for index, old_data in enumerate(old_rank_list):
                if data['rank'][0]['userid'] == old_data['userid']:
                    same_person_flag = True
                    if old_data['score'] > data['rank'][0]['score']:
                        del old_rank_list[index]
                        old_rank_list.append(data['rank'][0])
                        break
            logger.info("after old_rank_list={}".format(old_rank_list))
            if not same_person_flag:
                old_rank_list.append(data['rank'][0])
            logger.info("after old_rank_list={}".format(old_rank_list))
            old_rank_list.sort(key=lambda x:(x['score'], x['submitTime']))
            logger.info("after sort old_rank_list={}".format(old_rank_list))

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
        # old_rank_list.sort(key=lambda x:(-x['score'], x['submitTime']))
        # logger.info("after sort old_rank_list={}".format(old_rank_list))
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

class AIJoinAPI(APIView):
    def get(self, request):
        logger.info("get AIJoinAPI inin")
        problem_id = request.GET.get("problemID")
        # username input -> problem_id list output
        # data = request.data
        logger.info("problem_id={}".format(problem_id))
        # problem_id = data['problemID'] # 우리가 가져온 id - DisplayID
        # logger.info("data={}".format(data))
        problem = AIProblem.objects.get(_id=problem_id)
        # user_name = data['username']
        # logger.info("user_name={}".format(user_name))
        # user = User.objects.get(username = user_name)
        # logger.info("user={}".format(user))
        return self.success(problem.join_contest)
        
    def put(self, request):
        logger.info("post AIJoinAPI inin")
        # contest id 가져와야함
        data = request.data
        logger.info("data={}".format(data))
        problem_id = data['problemID']
        logger.info("problem_id={}".format(problem_id))
        user_name = data['username']
        logger.info("user_name={}".format(user_name))
        # profile = UserProfile.objects.get(username = user_name)
        problem = AIProblem.objects.get(_id=problem_id)
        new_join_contest = problem.join_contest
        logger.info("before new_join_contest={}".format(new_join_contest))
        if user_name not in new_join_contest:
            new_join_contest.append(user_name)
        else:
            logger.info("already in new_join_contest={}".format(new_join_contest))
        logger.info("after new_join_contest={}".format(new_join_contest))
        setattr(problem, 'join_contest', new_join_contest)
        problem.save()
        return self.success(problem.join_contest)