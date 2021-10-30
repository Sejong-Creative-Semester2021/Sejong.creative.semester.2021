from account.decorators import super_admin_required
from utils.api import APIView, validate_serializer

from recruit.models import Recruit
from recruit.serializers import (RecruitSerializer, CreateRecruitSerializer,
                                      EditRecruitSerializer)


class RecruitAdminAPI(APIView):
    @validate_serializer(CreateRecruitSerializer)
    @super_admin_required
    def post(self, request):
        """
        publish recruit
        """
        data = request.data
        recruit = Recruit.objects.create(title=data["title"],
                                        C_name=data["C_name"],
                                        created_by=request.user,
                                        visible=data["visible"])
        return self.success(RecruitSerializer(recruit).data)

    @validate_serializer(EditRecruitSerializer)
    @super_admin_required
    def put(self, request):
        """
        edit recruit
        """
        data = request.data
        try:
            recruit = Recruit.objects.get(id=data.pop("id"))
        except Recruit.DoesNotExist:
            return self.error("Recruit does not exist")

        for k, v in data.items():
            setattr(recruit, k, v)
        recruit.save()

        return self.success(RecruitSerializer(recruit).data)

    @super_admin_required
    def get(self, request):
        """
        get recruit list / get one recruit
        """
        recruit_id = request.GET.get("id")
        if recruit_id:
            try:
                recruit = Recruit.objects.get(id=recruit_id)
                return self.success(RecruitSerializer(recruit).data)
            except Recruit.DoesNotExist:
                return self.error("Recruit does not exist")
        recruit = Recruit.objects.all().order_by("-create_time")
        if request.GET.get("visible") == "true":
            recruit = recruit.filter(visible=True)
        return self.success(self.paginate_data(request, recruit, RecruitSerializer))

    @super_admin_required
    def delete(self, request):
        if request.GET.get("id"):
            Recruit.objects.filter(id=request.GET["id"]).delete()
        return self.success()
