from django.conf.urls import url

from ..views.oj import ProblemTagAPI, ProblemAPI, ContestProblemAPI, PickOneAPI, FileAPI, DataFileAPI, ProblemGeneralAPI, ProblemClassAPI, AIRankAPI

urlpatterns = [
    url(r"^aicontest/tags/?$", ProblemTagAPI.as_view(), name="problem_tag_list_api"),
    url(r"^aicontest/?$", ProblemAPI.as_view(), name="problem_api"),
    url(r"^pickone/?$", PickOneAPI.as_view(), name="pick_one_api"),
    url(r"^contest/problem/?$", ContestProblemAPI.as_view(), name="contest_problem_api"),
    url(r"^upload_csv/?$", FileAPI.as_view(), name="csv_file"),
    url(r"^data_csv/?$", DataFileAPI.as_view(), name="data_csv"),
    url(r"^aicontest_general/?$", ProblemGeneralAPI.as_view(), name="problem_general_api"),
    url(r"^aicontest_class/?$", ProblemClassAPI.as_view(), name="problem_class_api"),
    url(r"^rank/?$", AIRankAPI.as_view(), name="ai_rank")
]
