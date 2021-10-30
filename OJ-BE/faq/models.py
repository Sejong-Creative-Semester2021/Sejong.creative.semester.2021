from django.db import models

from account.models import User
from utils.models import RichTextField


class FAQ(models.Model):
    question = models.TextField()
    # HTML
    answer = RichTextField()
    create_time = models.DateTimeField(auto_now_add=True)
    created_by = models.ForeignKey(User, on_delete=models.CASCADE)
    last_update_time = models.DateTimeField(auto_now=True)
    visible = models.BooleanField(default=True)

    class Meta:
        db_table = "faq"
        ordering = ("-create_time",)
