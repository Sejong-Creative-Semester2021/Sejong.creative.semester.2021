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


class AIProblemType(Choices):
    General = "General"
    Class = "Class"


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
    # is_public = models.BooleanField(default=False)
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
    # samples = JSONField()
    # test_case_id = models.TextField()
    # [{"input_name": "1.in", "output_name": "1.out", "score": 0}]
    # test_case_score = JSONField()
    # hint = RichTextField(null=True)
    # languages = JSONField()
    # template = JSONField()
    create_time = models.DateTimeField(auto_now_add=True)
    # we can not use auto_now here
    last_update_time = models.DateTimeField(null=True)
    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    # ms
    # time_limit = models.IntegerField()
    # MB
    # memory_limit = models.IntegerField()
    # io mode
    # io_mode = JSONField(default=_default_io_mode)
    # special judge related
    # spj = models.BooleanField(default=False)
    # spj_language = models.TextField(null=True)
    # spj_code = models.TextField(null=True)
    # spj_version = models.TextField(null=True)
    # spj_compile_ok = models.BooleanField(default=False)
    # rule_type = models.TextField()
    visible = models.BooleanField(default=True)
    # difficulty = models.TextField()
    tags = models.ManyToManyField(AIProblemTag)
    # source = models.TextField(null=True)
    # # for OI mode
    # total_score = models.IntegerField(default=0)
    submission_number = models.BigIntegerField(default=0)
    accepted_number = models.BigIntegerField(default=0)
    # {JudgeStatus.ACCEPTED: 3, JudgeStaus.WRONG_ANSWER: 11}, the number means count
    # statistic_info = JSONField(default=dict)
    # share_submission = models.BooleanField(default=False)
    # # ?????? ??????
    # y_score = models.FloatField(default=False)
    # csv_file = models.FileField(null=True)
    solution_id = models.TextField(null=True)
    data_id = models.TextField(null=True)
    p_type = models.TextField(null=True)
    rank = JSONField(null=True, blank=True) # ????????? rank ??????
    password = models.CharField(max_length=20, null=True, blank=True)
    join_contest = JSONField(default=list, null=True, blank=True)
    eval_type = models.TextField(null=True)

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

