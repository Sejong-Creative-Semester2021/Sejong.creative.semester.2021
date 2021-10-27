from django.db import models
from utils.models import JSONField

from account.models import User
from contest.models import Contest
from utils.models import RichTextField
from utils.constants import Choices


class AIProblemTag(models.Model):
    name = models.TextField()

    class Meta:
        db_table = "ai_contest_tag"

class AIProblemRuleType(Choices):
    ACM = "ACM"
    OI = "OI"


class AIProblemDifficulty(object):
    High = "High"
    Mid = "Mid"
    Low = "Low"


class AIProblemIOMode(Choices):
    standard = "Standard IO"
    file = "File IO"


def _default_io_mode():
    return {"io_mode": AIProblemIOMode.standard, "input": "input.txt", "output": "output.txt"}


class AIProblem(models.Model):
    # display ID
    _id = models.TextField(db_index=True)
    contest = models.ForeignKey(Contest, null=True, on_delete=models.CASCADE)
    # for contest problem
    is_public = models.BooleanField(default=False)
    title = models.TextField()
    # HTML
    contest_description = RichTextField()
    # summary_description = RichTextField()
    rule_description = RichTextField()
    schedule_description = RichTextField(null=True)
    start_time = models.DateTimeField(null=True)
    end_time = models.DateTimeField(null=True)
    reward_description = RichTextField(null=True)
    data_description = RichTextField(null=True)
    # [{input: "test", output: "123"}, {input: "test123", output: "456"}]
    samples = JSONField()
    test_case_id = models.TextField()
    # [{"input_name": "1.in", "output_name": "1.out", "score": 0}]
    test_case_score = JSONField()
    hint = RichTextField(null=True)
    languages = JSONField()
    template = JSONField()
    create_time = models.DateTimeField(auto_now_add=True)
    # we can not use auto_now here
    last_update_time = models.DateTimeField(null=True)
    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    # ms
    # time_limit = models.IntegerField()
    # MB
    memory_limit = models.IntegerField()
    # io mode
    io_mode = JSONField(default=_default_io_mode)
    # special judge related
    spj = models.BooleanField(default=False)
    spj_language = models.TextField(null=True)
    spj_code = models.TextField(null=True)
    spj_version = models.TextField(null=True)
    spj_compile_ok = models.BooleanField(default=False)
    rule_type = models.TextField()
    visible = models.BooleanField(default=True)
    difficulty = models.TextField()
    tags = models.ManyToManyField(AIProblemTag)
    source = models.TextField(null=True)
    # for OI mode
    total_score = models.IntegerField(default=0)
    submission_number = models.BigIntegerField(default=0)
    accepted_number = models.BigIntegerField(default=0)
    # {JudgeStatus.ACCEPTED: 3, JudgeStaus.WRONG_ANSWER: 11}, the number means count
    statistic_info = JSONField(default=dict)
    share_submission = models.BooleanField(default=False)
    # # 추가 부분
    # y_score = models.FloatField(default=False)
    # csv_file = models.FileField(null=True)
    solution_id = models.TextField(null=True)
    rank = JSONField(default=dict) # 여기에 rank 추가

    class Meta:
        db_table = "ai_contest"
        unique_together = (("_id", "contest"),)
        ordering = ("create_time",)

    def add_submission_number(self):
        self.submission_number = models.F("submission_number") + 1
        self.save(update_fields=["submission_number"])

    def add_ac_number(self):
        self.accepted_number = models.F("accepted_number") + 1
        self.save(update_fields=["accepted_number"])


# 추가한 부분
# class AbstractContestRank(models.Model): # 이거를 base로 사용해서 ACMContestRank, OIContestRank 생성
#     user = models.ForeignKey(User, on_delete=models.CASCADE)
#     contest = models.ForeignKey(Contest, on_delete=models.CASCADE)
#     submission_number = models.IntegerField(default=0)

#     class Meta:
#         abstract = True

# # ACM이랑 OI 차이점 알고 우리한테 맞는게 뭔지 확인하기
# # 근데 어디서 submission_info를 받아오는거지?
# # 제일 궁금한거는 도대체 점수는 어디에다가 보관? - user에다가 보관안하고 바로 점수 rank하는 형식?

# class ACMContestRank(AbstractContestRank):
#     accepted_number = models.IntegerField(default=0)
#     # total_time is only for ACM contest, total_time =  ac time + none-ac times * 20 * 60
#     total_time = models.IntegerField(default=0)
#     # {"23": {"is_ac": True, "ac_time": 8999, "error_number": 2, "is_first_ac": True}}
#     # key is problem id
#     submission_info = JSONField(default=dict)

#     class Meta:
#         db_table = "acm_contest_rank"
#         unique_together = (("user", "contest"),)


# class OIContestRank(AbstractContestRank):
#     total_score = models.IntegerField(default=0)
#     # {"23": 333}
#     # key is problem id, value is current score
#     submission_info = JSONField(default=dict)

#     class Meta:
#         db_table = "oi_contest_rank"
#         unique_together = (("user", "contest"),)
