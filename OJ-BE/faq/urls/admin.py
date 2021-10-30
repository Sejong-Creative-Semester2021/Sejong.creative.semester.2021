from django.conf.urls import url

from ..views.admin import FAQAdminAPI

urlpatterns = [
    url(r"^faq/?$", FAQAdminAPI.as_view(), name="faq_admin_api"),
]
