from account.decorators import super_admin_required
from utils.api import APIView, validate_serializer

from faq.models import FAQ
from faq.serializers import (FAQSerializer, CreateFAQSerializer,
                                      EditFAQSerializer)
import logging
logger=logging.getLogger(__name__)

class FAQAdminAPI(APIView):
    @validate_serializer(CreateFAQSerializer)
    @super_admin_required
    def post(self, request):
        """
        publish faq
        """
        data = request.data
        faq = FAQ.objects.create(question=data["question"],
                                                   answer=data["answer"],
                                                   created_by=request.user,
                                                   visible=data["visible"])
        return self.success(FAQSerializer(faq).data)

    @validate_serializer(EditFAQSerializer)
    @super_admin_required
    def put(self, request):
        """
        edit faq
        """
        data = request.data
        try:
            faq = FAQ.objects.get(id=data.pop("id"))
        except FAQ.DoesNotExist:
            return self.error("FAQ does not exist")

        for k, v in data.items():
            setattr(faq, k, v)
        faq.save()

        return self.success(FAQSerializer(faq).data)

    @super_admin_required
    def get(self, request):
        """
        get faq list / get one faq
        """
        faq_id = request.GET.get("id")
        if faq_id:
            try:
                faq = FAQ.objects.get(id=faq_id)
                return self.success(FAQSerializer(faq).data)
            except FAQ.DoesNotExist:
                return self.error("FAQ does not exist")
        faq = FAQ.objects.all().order_by("-create_time")
        if request.GET.get("visible") == "true":
            faq = faq.filter(visible=True)
        return self.success(self.paginate_data(request, faq, FAQSerializer))

    @super_admin_required
    def delete(self, request):
        if request.GET.get("id"):
            FAQ.objects.filter(id=request.GET["id"]).delete()
        return self.success()
