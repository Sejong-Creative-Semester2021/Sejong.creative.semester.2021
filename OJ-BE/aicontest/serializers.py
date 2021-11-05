import re

from django import forms

from options.options import SysOptions
from utils.api import UsernameSerializer, serializers
from utils.constants import Difficulty
from utils.serializers import LanguageNameMultiChoiceField, SPJLanguageNameChoiceField, LanguageNameChoiceField

from .models import AIProblem, AIProblemRuleType, AIProblemTag, AIProblemIOMode, AIProblemType
from .utils import parse_problem_template

class DataFileUploadForm(forms.Form):
    file = forms.FileField()

class SolutionFileUploadForm(forms.Form):
    file = forms.FileField()

class FileUploadForm(forms.Form):
    id = forms.CharField(max_length=32)
    file = forms.FileField()
    
class TestCaseUploadForm(forms.Form):
    spj = forms.CharField(max_length=12)
    file = forms.FileField()


class CreateSampleSerializer(serializers.Serializer):
    input = serializers.CharField(trim_whitespace=False)
    output = serializers.CharField(trim_whitespace=False)


class CreateTestCaseScoreSerializer(serializers.Serializer):
    input_name = serializers.CharField(max_length=32)
    output_name = serializers.CharField(max_length=32)
    score = serializers.IntegerField(min_value=0)

class CreateRankSerializer(serializers.Serializer):
    userid = serializers.CharField(max_length=32)
    username = serializers.CharField(max_length=32)
    score = serializers.FloatField(min_value=0)

class CreateProblemCodeTemplateSerializer(serializers.Serializer):
    pass


class ProblemIOModeSerializer(serializers.Serializer):
    io_mode = serializers.ChoiceField(choices=AIProblemIOMode.choices())
    input = serializers.CharField()
    output = serializers.CharField()

    def validate(self, attrs):
        if attrs["input"] == attrs["output"]:
            raise serializers.ValidationError("Invalid io mode")
        for item in (attrs["input"], attrs["output"]):
            if not re.match("^[a-zA-Z0-9.]+$", item):
                raise serializers.ValidationError("Invalid io file name format")
        return attrs


class CreateOrEditProblemSerializer(serializers.Serializer):
    _id = serializers.CharField(max_length=32, allow_blank=True, allow_null=True)
    title = serializers.CharField(max_length=1024)
    contest_description = serializers.CharField()
    # summary_description = serializers.CharField()
    rule_description = serializers.CharField()
    schedule_description = serializers.CharField()
    start_time = serializers.DateTimeField()
    end_time = serializers.DateTimeField()
    reward_description = serializers.CharField()
    data_description = serializers.CharField()
    samples = serializers.ListField(child=CreateSampleSerializer(), allow_empty=False)
    test_case_id = serializers.CharField(max_length=32)
    test_case_score = serializers.ListField(child=CreateTestCaseScoreSerializer(), allow_empty=True)
    # time_limit = serializers.IntegerField(min_value=1, max_value=1000 * 60)
    memory_limit = serializers.IntegerField(min_value=1, max_value=1024)
    languages = LanguageNameMultiChoiceField()
    template = serializers.DictField(child=serializers.CharField(min_length=1))
    rule_type = serializers.ChoiceField(choices=[AIProblemRuleType.ACM, AIProblemRuleType.OI])
    io_mode = ProblemIOModeSerializer()
    spj = serializers.BooleanField()
    spj_language = SPJLanguageNameChoiceField(allow_blank=True, allow_null=True)
    spj_code = serializers.CharField(allow_blank=True, allow_null=True)
    spj_compile_ok = serializers.BooleanField(default=False)
    visible = serializers.BooleanField()
    difficulty = serializers.ChoiceField(choices=Difficulty.choices())
    tags = serializers.ListField(child=serializers.CharField(max_length=32), allow_empty=False)
    hint = serializers.CharField(allow_blank=True, allow_null=True)
    source = serializers.CharField(max_length=256, allow_blank=True, allow_null=True)
    share_submission = serializers.BooleanField()
    # csv_file = serializers.FileField()
    solution_id = serializers.CharField(max_length=32)
    data_id = serializers.CharField(max_length=32)
    p_type = serializers.ChoiceField(choices=[AIProblemType.General, AIProblemType.Class])
    rank = serializers.ListField(child=CreateRankSerializer(), allow_empty=True)


class CreateProblemSerializer(CreateOrEditProblemSerializer):
    pass


class EditProblemSerializer(CreateOrEditProblemSerializer):
    id = serializers.IntegerField()


class CreateContestProblemSerializer(CreateOrEditProblemSerializer):
    contest_id = serializers.IntegerField()


class EditContestProblemSerializer(CreateOrEditProblemSerializer):
    id = serializers.IntegerField()
    contest_id = serializers.IntegerField()


class TagSerializer(serializers.ModelSerializer):
    class Meta:
        model = AIProblemTag
        fields = "__all__"


class CompileSPJSerializer(serializers.Serializer):
    spj_language = SPJLanguageNameChoiceField()
    spj_code = serializers.CharField()


class BaseProblemSerializer(serializers.ModelSerializer):
    tags = serializers.SlugRelatedField(many=True, slug_field="name", read_only=True)
    created_by = UsernameSerializer()

    def get_public_template(self, obj):
        ret = {}
        for lang, code in obj.template.items():
            ret[lang] = parse_problem_template(code)["template"]
        return ret


class ProblemAdminSerializer(BaseProblemSerializer):
    class Meta:
        model = AIProblem
        fields = "__all__"


class ProblemSerializer(BaseProblemSerializer):
    template = serializers.SerializerMethodField("get_public_template")

    class Meta:
        model = AIProblem
        exclude = ("test_case_score", "test_case_id", "visible", "is_public",
                   "spj_code", "spj_version", "spj_compile_ok")


class ProblemSafeSerializer(BaseProblemSerializer):
    template = serializers.SerializerMethodField("get_public_template")

    class Meta:
        model = AIProblem
        exclude = ("test_case_score", "test_case_id", "visible", "is_public",
                   "spj_code", "spj_version", "spj_compile_ok",
                   "difficulty", "submission_number", "accepted_number", "statistic_info")


class ContestProblemMakePublicSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    display_id = serializers.CharField(max_length=32)


class ExportProblemSerializer(serializers.ModelSerializer):
    display_id = serializers.SerializerMethodField()
    contest_description = serializers.SerializerMethodField()
    # summary_description = serializers.SerializerMethodField()
    rule_description = serializers.SerializerMethodField()
    schedule_description = serializers.SerializerMethodField()
    start_time = serializers.DateTimeField()
    end_time = serializers.DateTimeField()
    reward_description = serializers.SerializerMethodField()
    data_description = serializers.SerializerMethodField()
    test_case_score = serializers.SerializerMethodField()
    hint = serializers.SerializerMethodField()
    spj = serializers.SerializerMethodField()
    template = serializers.SerializerMethodField()
    source = serializers.SerializerMethodField()
    tags = serializers.SlugRelatedField(many=True, slug_field="name", read_only=True)


    ## 함수는 아직 변경 안함
    def get_display_id(self, obj):
        return obj._id

    def _html_format_value(self, value):
        return {"format": "html", "value": value}

    def get_description(self, obj):
        return self._html_format_value(obj.contest_description)

    # def get_input_description(self, obj):
    #     return self._html_format_value(obj.summary_description)

    def get_output_description(self, obj):
        return self._html_format_value(obj.rule_description)
    
    def get_schedule_description(self, obj):
        return self._html_format_value(obj.schedule_description)

    def get_start_time(self, obj):
        return obj.start_time

    def get_end_time(self, obj):
        return obj.end_time

    def get_hint(self, obj):
        return self._html_format_value(obj.hint)

    def get_test_case_score(self, obj):
        return [{"score": item["score"] if obj.rule_type == AIProblemRuleType.OI else 100,
                 "input_name": item["input_name"], "output_name": item["output_name"]}
                for item in obj.test_case_score]

    def get_spj(self, obj):
        return {"code": obj.spj_code,
                "language": obj.spj_language} if obj.spj else None

    def get_template(self, obj):
        ret = {}
        for k, v in obj.template.items():
            ret[k] = parse_problem_template(v)
        return ret

    def get_source(self, obj):
        return obj.source or f"{SysOptions.website_name} {SysOptions.website_base_url}"

    class Meta:
        model = AIProblem
        fields = ("display_id", "title", "contest_description", "tags",
                  "rule_description", "schedule_description",
                  "start_time", "end_time", "reward_description", "data_description",
                  "test_case_score", "hint", "memory_limit", "samples",
                  "template", "spj", "rule_type", "source", "template", "solution_id", "rank")


class AddContestProblemSerializer(serializers.Serializer):
    contest_id = serializers.IntegerField()
    problem_id = serializers.IntegerField()
    display_id = serializers.CharField()


class ExportProblemRequestSerialzier(serializers.Serializer):
    problem_id = serializers.ListField(child=serializers.IntegerField(), allow_empty=False)


class UploadProblemForm(forms.Form):
    file = forms.FileField()


class FormatValueSerializer(serializers.Serializer):
    format = serializers.ChoiceField(choices=["html", "markdown"])
    value = serializers.CharField(allow_blank=True)


class TestCaseScoreSerializer(serializers.Serializer):
    score = serializers.IntegerField(min_value=1)
    input_name = serializers.CharField(max_length=32)
    output_name = serializers.CharField(max_length=32)


class TemplateSerializer(serializers.Serializer):
    prepend = serializers.CharField()
    template = serializers.CharField()
    append = serializers.CharField()


class SPJSerializer(serializers.Serializer):
    code = serializers.CharField()
    language = SPJLanguageNameChoiceField()


class AnswerSerializer(serializers.Serializer):
    code = serializers.CharField()
    language = LanguageNameChoiceField()


class ImportProblemSerializer(serializers.Serializer):
    display_id = serializers.CharField(max_length=128)
    title = serializers.CharField(max_length=128)
    contest_description = FormatValueSerializer()
    # summary_description = FormatValueSerializer()
    rule_description = FormatValueSerializer()
    schedule_description = FormatValueSerializer()
    start_time = serializers.DateTimeField()
    end_time = serializers.DateTimeField()
    reward_description = FormatValueSerializer()
    data_description = FormatValueSerializer()
    hint = FormatValueSerializer()
    test_case_score = serializers.ListField(child=TestCaseScoreSerializer(), allow_null=True)
    # time_limit = serializers.IntegerField(min_value=1, max_value=60000)
    memory_limit = serializers.IntegerField(min_value=1, max_value=10240)
    samples = serializers.ListField(child=CreateSampleSerializer())
    template = serializers.DictField(child=TemplateSerializer())
    spj = SPJSerializer(allow_null=True)
    rule_type = serializers.ChoiceField(choices=AIProblemRuleType.choices())
    source = serializers.CharField(max_length=200, allow_blank=True, allow_null=True)
    answers = serializers.ListField(child=AnswerSerializer())
    tags = serializers.ListField(child=serializers.CharField())


class FPSProblemSerializer(serializers.Serializer):
    class UnitSerializer(serializers.Serializer):
        unit = serializers.ChoiceField(choices=["MB", "s", "ms"])
        value = serializers.IntegerField(min_value=1, max_value=60000)

    title = serializers.CharField(max_length=128)
    contest_description = serializers.CharField()
    reward_description = serializers.CharField()
    data_description = serializers.CharField()
    input = serializers.CharField()
    output = serializers.CharField()
    hint = serializers.CharField(allow_blank=True, allow_null=True)
    # time_limit = UnitSerializer()
    memory_limit = UnitSerializer()
    samples = serializers.ListField(child=CreateSampleSerializer())
    source = serializers.CharField(max_length=200, allow_blank=True, allow_null=True)
    spj = SPJSerializer(allow_null=True)
    template = serializers.ListField(child=serializers.DictField(), allow_empty=True, allow_null=True)
    append = serializers.ListField(child=serializers.DictField(), allow_empty=True, allow_null=True)
    prepend = serializers.ListField(child=serializers.DictField(), allow_empty=True, allow_null=True)
