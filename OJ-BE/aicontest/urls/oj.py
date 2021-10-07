from django.conf.urls import url

from ..views.oj import ProblemTagAPI, ProblemAPI, ContestProblemAPI, PickOneAPI

urlpatterns = [
    url(r"^aicontest/tags/?$", ProblemTagAPI.as_view(), name="problem_tag_list_api"),
    url(r"^aicontest/?$", ProblemAPI.as_view(), name="problem_api"),
    url(r"^pickone/?$", PickOneAPI.as_view(), name="pick_one_api"),
    url(r"^contest/problem/?$", ContestProblemAPI.as_view(), name="contest_problem_api"),
]
