# Generated by Django 3.2.6 on 2021-11-20 16:30

import django.contrib.postgres.fields.jsonb
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('account', '0002_userprofile_user_join_contest'),
    ]

    operations = [
        migrations.AddField(
            model_name='userprofile',
            name='submit_info',
            field=django.contrib.postgres.fields.jsonb.JSONField(default=list),
        ),
    ]
