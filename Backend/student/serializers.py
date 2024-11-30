# serializers.py
from rest_framework import serializers
from course.models import Course, CourseEnrollment
from instructor.models import Document, Example, Exercise

class CourseSerializer(serializers.ModelSerializer):
    instructor_name = serializers.CharField(source='instructor.get_full_name', read_only=True)
    grade_name = serializers.CharField(source='grade.gradename', read_only=True)
    
    class Meta:
        model = Course
        fields = [
            'id',
            'name',
            'description',
            'instructor_name',
            'grade_name',
            'created_at',
        ]

class CourseEnrollmentSerializer(serializers.ModelSerializer):
    course = CourseSerializer(read_only=True)
    
    class Meta:
        model = CourseEnrollment
        fields = [
            'id',
            'course',
            'enrolled_at',
            'is_active',
        ]




class RecommendationBaseSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    title = serializers.CharField()
    content = serializers.CharField()
    confidence_score = serializers.FloatField()

class ExerciseRecommendationSerializer(serializers.ModelSerializer):
    title = serializers.CharField(source='content')  # Using content as title since Exercise might not have a title field
    confidence_score = serializers.SerializerMethodField()

    class Meta:
        model = Exercise
        fields = ['exercise_id', 'title', 'content', 'confidence_score']

    def get_confidence_score(self, obj):
        # Get the confidence score from the related ExerciseStandard if available
        exercise_standard = getattr(obj, 'exercisestandard', None)
        return exercise_standard.confidence_score if exercise_standard else 0.0

class ExampleRecommendationSerializer(serializers.ModelSerializer):
    title = serializers.CharField(source='content')  # Adjust based on your Example model fields
    confidence_score = serializers.SerializerMethodField()

    class Meta:
        model = Example
        fields = ['id', 'title', 'content', 'confidence_score']

    def get_confidence_score(self, obj):
        example_standard = getattr(obj, 'examplestandard', None)
        return example_standard.confidence_score if example_standard else 0.0

class DocumentRecommendationSerializer(serializers.ModelSerializer):
    confidence_score = serializers.SerializerMethodField()

    class Meta:
        model = Document
        fields = ['id', 'title', 'description', 'confidence_score']

    def get_confidence_score(self, obj):
        document_standard = getattr(obj, 'documentstandard', None)
        return document_standard.confidence_score if document_standard else 0.0
