# Generated by Django 5.1.1 on 2024-11-29 14:04

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('course', '0001_initial'),
        ('instructor', '0005_clusters_standards_example_exercise_documentstandard_and_more'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.AlterUniqueTogether(
            name='assessmentexercise',
            unique_together={('assessment', 'exercise'), ('assessment', 'order')},
        ),
        migrations.AlterField(
            model_name='courseenrollment',
            name='course',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='enrollments', to='course.course'),
        ),
        migrations.AlterField(
            model_name='courseenrollment',
            name='student',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='course_enrollments', to=settings.AUTH_USER_MODEL),
        ),
        migrations.RemoveField(
            model_name='assessmentexercise',
            name='points',
        ),
    ]