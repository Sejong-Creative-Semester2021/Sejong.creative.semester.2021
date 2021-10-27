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
# import pandas as pd
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

        # 임시
        y_score = 10
        # 여기서 받은 y_score를 유저명과 함께 rank에 넣어준다 json형식으로


        return self.success({"id": predict_id, "info": info})

# class AIRankAPI(APIView)
#     # 생각한 방법 - aicontest model에 leaderboard 리스트 생성
#     # 여기에 등수, 유저명, 점수 <- 이 세가지를 저장할 예정
#     # 학생이 제출한 점수를 받으면 leaderborad에 저장 -> 정렬해서 등수를 오름차순으로 표시
#     # 찾아보니 listfield가 있는지도 확실x -> 분명한거는 이런 방식으로 사용하지 말라고함 -> 다른 방법 써치
#     # contest에서 사용한 것을 보니까 models에 AbstractContestRank 만들어서 여기에 rank 저장하는 방식으로 저장
#     def get_rank(self):
#         if self.contest.rule_type == ContestRuleType.ACM:
#             return ACMContestRank.objects.filter(contest=self.contest,
#                                                  user__admin_type=AdminType.REGULAR_USER,
#                                                  user__is_disabled=False).\
#                 select_related("user").order_by("-accepted_number", "total_time")
#         else:
#             return OIContestRank.objects.filter(contest=self.contest,
#                                                 user__admin_type=AdminType.REGULAR_USER,
#                                                 user__is_disabled=False). \
#                 select_related("user").order_by("-total_score")

#     def column_string(self, n):
#         string = ""
#         while n > 0:
#             n, remainder = divmod(n - 1, 26)
#             string = chr(65 + remainder) + string
#         return string

#     @check_contest_permission(check_type="ranks")
#     def get(self, request):
#         download_csv = request.GET.get("download_csv")
#         force_refresh = request.GET.get("force_refresh")
#         is_contest_admin = request.user.is_authenticated and request.user.is_contest_admin(self.contest)
#         if self.contest.rule_type == ContestRuleType.OI:
#             serializer = OIContestRankSerializer
#         else:
#             serializer = ACMContestRankSerializer

#         if force_refresh == "1" and is_contest_admin:
#             qs = self.get_rank()
#         else:
#             cache_key = f"{CacheKey.contest_rank_cache}:{self.contest.id}"
#             qs = cache.get(cache_key)
#             if not qs:
#                 qs = self.get_rank()
#                 cache.set(cache_key, qs)

#         if download_csv:
#             data = serializer(qs, many=True, is_contest_admin=is_contest_admin).data
#             contest_problems = Problem.objects.filter(contest=self.contest, visible=True).order_by("_id")
#             problem_ids = [item.id for item in contest_problems]

#             f = io.BytesIO()
#             workbook = xlsxwriter.Workbook(f)
#             worksheet = workbook.add_worksheet()
#             worksheet.write("A1", "User ID")
#             worksheet.write("B1", "Username")
#             worksheet.write("C1", "Real Name")
#             if self.contest.rule_type == ContestRuleType.OI:
#                 worksheet.write("D1", "Total Score")
#                 for item in range(contest_problems.count()):
#                     worksheet.write(self.column_string(5 + item) + "1", f"{contest_problems[item].title}")
#                 for index, item in enumerate(data):
#                     worksheet.write_string(index + 1, 0, str(item["user"]["id"]))
#                     worksheet.write_string(index + 1, 1, item["user"]["username"])
#                     worksheet.write_string(index + 1, 2, item["user"]["real_name"] or "")
#                     worksheet.write_string(index + 1, 3, str(item["total_score"]))
#                     for k, v in item["submission_info"].items():
#                         worksheet.write_string(index + 1, 4 + problem_ids.index(int(k)), str(v))
#             else:
#                 worksheet.write("D1", "AC")
#                 worksheet.write("E1", "Total Submission")
#                 worksheet.write("F1", "Total Time")
#                 for item in range(contest_problems.count()):
#                     worksheet.write(self.column_string(7 + item) + "1", f"{contest_problems[item].title}")

#                 for index, item in enumerate(data):
#                     worksheet.write_string(index + 1, 0, str(item["user"]["id"]))
#                     worksheet.write_string(index + 1, 1, item["user"]["username"])
#                     worksheet.write_string(index + 1, 2, item["user"]["real_name"] or "")
#                     worksheet.write_string(index + 1, 3, str(item["accepted_number"]))
#                     worksheet.write_string(index + 1, 4, str(item["submission_number"]))
#                     worksheet.write_string(index + 1, 5, str(item["total_time"]))
#                     for k, v in item["submission_info"].items():
#                         worksheet.write_string(index + 1, 6 + problem_ids.index(int(k)), str(v["is_ac"]))

#             workbook.close()
#             f.seek(0)
#             response = HttpResponse(f.read())
#             response["Content-Disposition"] = f"attachment; filename=content-{self.contest.id}-rank.xlsx"
#             response["Content-Type"] = "application/xlsx"
#             return response

#         page_qs = self.paginate_data(request, qs)
#         page_qs["results"] = serializer(page_qs["results"], many=True, is_contest_admin=is_contest_admin).data
#         return self.success(page_qs)