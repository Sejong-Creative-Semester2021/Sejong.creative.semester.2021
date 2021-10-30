from django.conf.urls import url

from ..views.oj import FAQAPI

urlpatterns = [
    url(r"^faq/?$", FAQAPI.as_view(), name="faq_api"),
]
