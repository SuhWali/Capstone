
# models.py
from django.db import models
from django.contrib.auth import get_user_model
from django.utils import timezone

User = get_user_model()


class Grade(models.Model):
    # Map to existing grade table
    class Meta:
        managed = False  # Tells Django not to manage this table
        db_table = 'grades'  # Use your actual table name
        
    # Define fields exactly as they exist in your DB
    gradeid = models.AutoField(primary_key=True)
    gradename = models.CharField(max_length=100)
    # Add other fields that exist in your table


class Domain(models.Model):
    domainid = models.AutoField(primary_key=True)
    domainname = models.CharField(max_length=100)
    gradeid = models.ForeignKey('Grade', db_column='gradeid', on_delete=models.CASCADE)
    domain_abb = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'domains'




# New table for instructor-grade relationship
class InstructorGrade(models.Model):
    instructor = models.ForeignKey(User, on_delete=models.CASCADE, related_name='instructor_grades')
    grade = models.ForeignKey(Grade, on_delete=models.CASCADE, related_name='instructors')
    assigned_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'instructor_grade'  # Specify the table name you want
        unique_together = ('instructor', 'grade')






def document_upload_path(instance, filename):
    # Files will be uploaded to MEDIA_ROOT/documents/domain_<id>/instructor_<id>/<filename>
    return f'documents/domain_{instance.domain.domainid}/instructor_{instance.instructor.id}/{filename}'

class Document(models.Model):
    id = models.AutoField(primary_key=True)
    instructor = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='documents',
        db_column='instructor_id'
    )
    domain = models.ForeignKey(
        'Domain',  # Reference to your existing Domain model
        on_delete=models.CASCADE,
        related_name='documents',
        db_column='domain_id'
    )
    title = models.CharField(max_length=255)
    description = models.TextField(null=True, blank=True)
    upload_date = models.DateTimeField(default=timezone.now)
    file = models.FileField(
        upload_to=document_upload_path,
        max_length=500,
    )

    class Meta:
        db_table = 'documents'
        ordering = ['-upload_date']

    def __str__(self):
        return f"{self.title} - {self.domain.domainname} - {self.instructor.username}"   #  pylint: disable=E1101
    
    # def delete(self, *args, **kwargs):
    #     # Delete the file when the model instance is deleted
    #     if self.file:
    #         self.file.delete()
    #     super().delete(*args, **kwargs)
