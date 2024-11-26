
# models.py
from django.db import models
from django.contrib.auth import get_user_model
from django.utils import timezone
from typing import Dict, Tuple
from pathlib import Path
import json
from django.db import transaction


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
    grade = models.ForeignKey('Grade', db_column='gradeid', on_delete=models.CASCADE)
    domain_abb = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'domains'


class Clusters(models.Model):
    clusterid = models.AutoField(primary_key=True)
    domainid = models.ForeignKey('Domain', db_column='domainid', on_delete=models.CASCADE)
    clustername = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'clusters'


class Standards(models.Model):
    standardid = models.AutoField(primary_key=True)
    clusterid =  models.ForeignKey('Clusters', db_column='clusterid', on_delete=models.CASCADE)
    standardcode = models.CharField(max_length=50)
    standarddescription = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'standards'


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

    def get_analysis_paths(self) -> Tuple[str, str]:
        """Get paths for both analysis files."""
        base_path = Path(self.file.path)
        concepts_path = str(base_path.parent / f"{base_path.stem}_concepts.json")
        exercises_path = str(base_path.parent / f"{base_path.stem}_exercises.json")
        return concepts_path, exercises_path

    @transaction.atomic
    def process_content(self) -> Dict:
        """Single entry point for all document content processing."""
        from .utils.content_processor import ContentProcessor
        
        # Initialize processor with configurable threshold
        processor = ContentProcessor(threshold=0.7)
        
        # Process document content and store relationships
        processing_results = processor.process_document_content(self)
        
        # Store NLI analysis results
        self._save_nli_analysis(processing_results)
        
        return processing_results

    def _save_nli_analysis(self, results: Dict) -> None:
        """Save NLI analysis results to file."""
        nli_path = Path(self.file.path).parent / f"{Path(self.file.path).stem}_nli_analysis.json"
        with open(nli_path, 'w', encoding='utf-8') as f:
            json.dump(results, f, indent=2)

    def get_nli_analysis(self) -> Dict:
        """Get stored NLI analysis results."""
        nli_path = Path(self.file.path).parent / f"{Path(self.file.path).stem}_nli_analysis.json"
        try:
            with open(nli_path, 'r', encoding='utf-8') as f:
                return json.load(f)
        except FileNotFoundError:
            return self.process_content()
    
    class Meta:
        db_table = 'documents'
        ordering = ['-upload_date']
    # def delete(self, *args, **kwargs):
    #     # Delete the file when the model instance is deleted
    #     if self.file:
    #         self.file.delete()
    #     super().delete(*args, **kwargs)


class DocumentStandard(models.Model):
    document = models.ForeignKey(
        Document,
        on_delete=models.CASCADE,
        db_column='document_id'
    )
    standard = models.ForeignKey(
        'Standards',
        on_delete=models.CASCADE,
        db_column='standard_id'
    )
    confidence_score = models.FloatField(
        help_text="NLI confidence score for this document-standard relationship"
    )
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'document_standards'
        unique_together = ['document', 'standard']
        indexes = [
            models.Index(fields=['document', 'standard']),
            models.Index(fields=['confidence_score']),
        ]


class Exercise(models.Model):
    exercise_id = models.AutoField(primary_key=True)

    type = models.CharField(max_length=50)
    content = models.TextField()
    context = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    # standards = models.ManyToManyField(
    #     'Standard',
    #     through='ExerciseStandard',
    #     related_name='exercises'
    # )

    class Meta:
        db_table = 'exercises'


class Example(models.Model):
    example_id = models.AutoField(primary_key=True)
 
    type = models.CharField(max_length=50)
    content = models.TextField()
    context = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)


    class Meta:
        db_table = 'examples'

class ExerciseStandard(models.Model):
    exercise = models.ForeignKey(Exercise, on_delete=models.CASCADE)
    standard = models.ForeignKey('Standards', on_delete=models.CASCADE)
    confidence_score = models.FloatField()

    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'exercise_standards'
        unique_together = ['exercise', 'standard']

class ExampleStandard(models.Model):
    example = models.ForeignKey(Example, on_delete=models.CASCADE)
    standard = models.ForeignKey('Standards', on_delete=models.CASCADE)
    confidence_score = models.FloatField()

    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'example_standards'
        unique_together = ['example', 'standard']