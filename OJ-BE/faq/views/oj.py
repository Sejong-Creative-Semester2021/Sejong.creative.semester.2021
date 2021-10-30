from utils.api import APIView

from faq.models import FAQ
from faq.serializers import FAQSerializer

import logging
logger=logging.getLogger(__name__)


class FAQAPI(APIView):
    def get(self, request):
        logger.info('faq enter!')
        faqs = FAQ.objects.filter(visible=True)
        logger.debug('faq load success!')
        return self.success(self.paginate_data(request, faqs, FAQSerializer))
