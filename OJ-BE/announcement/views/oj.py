from utils.api import APIView
from django.db.models import Q
from announcement.models import Announcement
from announcement.serializers import AnnouncementSerializer
import logging
logger=logging.getLogger(__name__)

class AnnouncementAPI(APIView):
    def get(self, request):
        announcements = Announcement.objects.filter(visible=True)
        limit = request.GET.get("limit")
        if not limit:
            return self.error("Limit is needed")
        keyword = request.GET.get("keyword", "").strip()
        logger.info("keyword: {}".format(keyword))
        logger.info("keyword get success")
        if keyword:
            announcements = announcements.filter(Q(title__icontains=keyword))
        logger.info("success!")
        return self.success(self.paginate_data(request, announcements, AnnouncementSerializer))
