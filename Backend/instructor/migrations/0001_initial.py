# Generated by Django 5.1.1 on 2024-11-22 11:13

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Domain',
            fields=[
                ('domainid', models.AutoField(primary_key=True, serialize=False)),
                ('gradeid', models.CharField(max_length=100)),
                ('domainname', models.TextField(blank=True, null=True)),
            ],
            options={
                'db_table': 'domains',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Grade',
            fields=[
                ('gradeid', models.AutoField(primary_key=True, serialize=False)),
                ('gradename', models.CharField(max_length=100)),
            ],
            options={
                'db_table': 'grades',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Document',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(max_length=255)),
                ('file', models.FileField(upload_to='documents/')),
                ('uploaded_at', models.DateTimeField(auto_now_add=True)),
                ('description', models.TextField(blank=True, null=True)),
                ('domain', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='documents', to='instructor.domain')),
                ('uploaded_by', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'db_table': 'document',
            },
        ),
        migrations.CreateModel(
            name='InstructorGrade',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('assigned_at', models.DateTimeField(auto_now_add=True)),
                ('grade', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='instructors', to='instructor.grade')),
                ('instructor', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='instructor_grades', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'db_table': 'instructor_grade',
                'unique_together': {('instructor', 'grade')},
            },
        ),
    ]
