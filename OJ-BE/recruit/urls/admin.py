from django.conf.urls import url

from ..views.admin import RecruitAdminAPI

urlpatterns = [
    url(r"^recruit/?$", RecruitAdminAPI.as_view(), name="recruit_admin_api"),
]
