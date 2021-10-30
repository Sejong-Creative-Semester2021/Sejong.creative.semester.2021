from utils.api import serializers
from utils.api._serializers import UsernameSerializer

from .models import FAQ


class CreateFAQSerializer(serializers.Serializer):
    question = serializers.CharField(max_length=64)
    answer = serializers.CharField(max_length=1024 * 1024 * 8)
    visible = serializers.BooleanField()


class FAQSerializer(serializers.ModelSerializer):
    created_by = UsernameSerializer()

    class Meta:
        model = FAQ
        fields = "__all__"


class EditFAQSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    question = serializers.CharField(max_length=64)
    answer = serializers.CharField(max_length=1024 * 1024 * 8)
    visible = serializers.BooleanField()
