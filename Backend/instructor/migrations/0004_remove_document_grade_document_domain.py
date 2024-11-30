# Generated by Django 5.1.1 on 2024-11-24 15:05

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('instructor', '0003_document_grade'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='document',
            name='grade',
        ),
        migrations.AddField(
            model_name='document',
            name='domain',
            field=models.ForeignKey(db_column='domain_id', default=2, on_delete=django.db.models.deletion.CASCADE, related_name='documents', to='instructor.domain'),
            preserve_default=False,
        ),
    ]