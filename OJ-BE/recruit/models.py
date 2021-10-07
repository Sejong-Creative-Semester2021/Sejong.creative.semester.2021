from django.db import models

from account.models import User
from utils.models import RichTextField
from utils.models import JSONField


class Recruit(models.Model):
    C_name = models.TextField()
    title = models.TextField()
    # HTML
    create_time = models.DateTimeField(auto_now_add=True)
    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    last_update_time = models.DateTimeField(auto_now=True)
    visible = models.BooleanField(default=True)

    # job = JSONField()
    # location = JSONField()
    # career= JSONField()
    # worktype=JSONField()

    class Meta:
        db_table = "recruit"
        ordering = ("-create_time",)
