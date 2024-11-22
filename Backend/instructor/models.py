
# models.py
from django.db import models
from django.contrib.auth import get_user_model

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
    # Map to existing domain table
    class Meta:
        managed = False  # Tells Django not to manage this table
        db_table = 'domains'  # Use your actual table name
        
    # Define fields exactly as they exist in your DB
    domainid = models.AutoField(primary_key=True)
    gradeid = models.CharField(max_length=100)
    domain_abb = models.ForeignKey(Grade, on_delete=models.CASCADE)
    domainname = models.TextField(null=True, blank=True)




# New table for instructor-grade relationship
class InstructorGrade(models.Model):
    instructor = models.ForeignKey(User, on_delete=models.CASCADE, related_name='instructor_grades')
    grade = models.ForeignKey(Grade, on_delete=models.CASCADE, related_name='instructors')
    assigned_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'instructor_grade'  # Specify the table name you want
        unique_together = ('instructor', 'grade')



# New table for documents
class Document(models.Model):
    title = models.CharField(max_length=255)
    file = models.FileField(upload_to='documents/')
    domain = models.ForeignKey(Domain, on_delete=models.CASCADE, related_name='documents')
    uploaded_by = models.ForeignKey(User, on_delete=models.CASCADE)
    uploaded_at = models.DateTimeField(auto_now_add=True)
    description = models.TextField(null=True, blank=True)

    class Meta:
        db_table = 'document'  # Specify the table name you want