from rest_framework.decorators import action


from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated

from rest_framework.response import Response
from rest_framework import serializers

import logging
from .serializers import AssessmentSerializer, CourseSerializer
from .models import Assessment, Course

logger = logging.getLogger(__name__)

class AssessmentViewSet(viewsets.ModelViewSet):
    serializer_class = AssessmentSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        
        return Assessment.objects.filter(created_by=self.request.user)

    def perform_create(self, serializer):
        print("DEBUG: Perform create called")

        serializer.save(created_by=self.request.user)

class CourseViewSet(viewsets.ViewSet):
    permission_classes = [IsAuthenticated]
    @action(detail=False, methods=['GET'])

    # def get_queryset(self):
    #     return Assessment.objects.filter(created_by=self.request.user)
    def my_courses(self, request):
        
        instructor_courses = Course.objects.filter(instructor=request.user)
        # Extract the grades from the courses
        course = [course for course in instructor_courses]
        # Remove duplicates if an instructor teaches multiple courses in the same grade
        courses = list(dict.fromkeys(course))
        serializer = CourseSerializer(courses, many=True)
        return Response(serializer.data)
