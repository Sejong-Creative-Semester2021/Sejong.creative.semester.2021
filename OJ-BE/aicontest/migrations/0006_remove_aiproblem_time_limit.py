# Generated by Django 3.2.6 on 2021-08-26 12:36

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('aicontest', '0005_aiproblem_schedule_description'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='aiproblem',
            name='time_limit',
        ),
    ]