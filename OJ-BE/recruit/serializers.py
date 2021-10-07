from utils.api import serializers
from utils.api._serializers import UsernameSerializer

from .models import Recruit

class CreateRecruitSerializer(serializers.Serializer):
    C_name = serializers.CharField(max_length=64)
    title = serializers.CharField(max_length=64)
    visible = serializers.BooleanField()


class RecruitSerializer(serializers.ModelSerializer):
    created_by = UsernameSerializer()

    class Meta:
        model = Recruit
        fields = "__all__"


class EditRecruitSerializer(serializers.Serializer):
    C_name = serializers.CharField(max_length=64)
    title = serializers.CharField(max_length=64)
    visible = serializers.BooleanField()
