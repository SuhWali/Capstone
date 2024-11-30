from django.db import models

from instructor.models import Grade, Exercise
from django.contrib.auth import get_user_model

from django.core.validators import MinValueValidator

User = get_user_model()

class Course(models.Model):
    grade = models.ForeignKey(Grade, on_delete=models.CASCADE, related_name='courses')
    students = models.ManyToManyField(User, through='CourseEnrollment', related_name='enrolled_courses')
    instructor = models.ForeignKey(User, on_delete=models.CASCADE, related_name='taught_courses')
    name = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.name} - Grade {self.grade.gradename}"

class CourseEnrollment(models.Model):
    student = models.ForeignKey(User, on_delete=models.CASCADE, related_name='course_enrollments')
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='enrollments')
    enrolled_at = models.DateTimeField(auto_now_add=True)
    is_active = models.BooleanField(default=True)

    class Meta:
        unique_together = ['student', 'course']

    def __str__(self):
        return f"{self.student.username} enrolled in {self.course.name}"

class Assessment(models.Model):
    title = models.CharField(max_length=255)
    course = models.ForeignKey('Course', on_delete=models.CASCADE, related_name='assessments')
    created_by = models.ForeignKey(User, on_delete=models.CASCADE, related_name='created_assessments')
    is_generated = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.title} - {self.course.name}"

class AssessmentExercise(models.Model):
    assessment = models.ForeignKey(Assessment, on_delete=models.CASCADE, related_name='exercises')
    exercise = models.ForeignKey(Exercise, on_delete=models.CASCADE)
    order = models.PositiveIntegerField()

    class Meta:
        ordering = ['order']
        unique_together = [
            ['assessment', 'exercise'],
            ['assessment', 'order'],
        ]
