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
# import pandas as pd test
# import numpy as np

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
        problem_id = request.GET.get("problem_id")
        if problem_id:
            try:
                problem = AIProblem.objects.select_related("created_by") \
                    .get(_id=problem_id, contest_id__isnull=True, visible=True)
                problem_data = ProblemSerializer(problem).data
                self._add_problem_status(request, problem_data)
                return self.success(problem_data)
            except AIProblem.DoesNotExist:
                return self.error("Problem does not exist")

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

        # y_true = np.array(pd.read_csv(os.path.join(settings.SOLUTION_DIR, csv.solution_id, "solution.csv")))
        # y_pred = np.array(pd.read_csv(os.path.join(settings.PREDICT_DIR, predict_id, "predict.csv")))

        # logger.info("y_true={}".format(y_true))
        # logger.info("y_pred={}".format(y_pred))

        # y_score = (y_true.astype(bool) == y_pred.astype(bool)).mean()
        # logger.info("y_score={}".format(y_score))
        
        os.remove(tmp_file)

        return self.success({"id": predict_id, "info": info})


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
        
    def get(self, request):
        # 问题详情页
        problem_id = request.GET.get("problem_id")
        if problem_id:
            try:
                problem = AIProblem.objects.select_related("created_by") \
                    .get(_id=problem_id, contest_id__isnull=True, visible=True)
                problem_data = ProblemSerializer(problem).data
                self._add_problem_status(request, problem_data)
                return self.success(problem_data)
            except AIProblem.DoesNotExist:
                return self.error("Problem does not exist")

        limit = request.GET.get("limit")
        if not limit:
            return self.error("Limit is needed")

        problems = AIProblem.objects.select_related("created_by").filter(contest_id__isnull=True, visible=True, p_type='General')

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

class ProblemClassAPI(APIView):
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
        
    def get(self, request):
        # 问题详情页
        problem_id = request.GET.get("problem_id")
        if problem_id:
            try:
                problem = AIProblem.objects.select_related("created_by") \
                    .get(_id=problem_id, contest_id__isnull=True, visible=True)
                problem_data = ProblemSerializer(problem).data
                self._add_problem_status(request, problem_data)
                return self.success(problem_data)
            except AIProblem.DoesNotExist:
                return self.error("Problem does not exist")

        limit = request.GET.get("limit")
        if not limit:
            return self.error("Limit is needed")

        problems = AIProblem.objects.select_related("created_by").filter(contest_id__isnull=True, visible=True, p_type='Class')

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