# assessments/views.py
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.db.models import Q
from .models import Assessment, AssessmentExercise, Course
from .serializers import AssessmentSerializer, GenerateAssessmentSerializer
from instructor.models import Exercise, Standards
import logging

logger = logging.getLogger(__name__)
class AssessmentViewSet(viewsets.ModelViewSet):
    serializer_class = AssessmentSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Assessment.objects.filter(created_by=self.request.user)

    @action(detail=False, methods=['post'])
    def generate(self, request):
        """Generate an assessment from existing exercises."""
        serializer = GenerateAssessmentSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        course_id = serializer.validated_data['course_id']
        domain_id = serializer.validated_data.get('domain_id')
        cluster_id = serializer.validated_data.get('cluster_id')
        num_exercises = serializer.validated_data.get('num_exercises', 10)

        # Validate course ownership
        try:
            course = Course.objects.get(id=course_id, instructor=request.user)
        except Course.DoesNotExist:
            return Response(
                {"error": "You do not have permission to generate an assessment for this course."},
                status=status.HTTP_403_FORBIDDEN
            )

        # Build query based on provided filters
        if cluster_id:
            standards = Standards.objects.filter(
                clusterid=cluster_id
            ).values_list('standardid', flat=True)
        elif domain_id:
            standards = Standards.objects.filter(
                clusterid__domainid=domain_id
            ).values_list('standardid', flat=True)

        logger.debug(f"Standards selected: {standards}")

        # Get exercises linked to these standards
        exercises = Exercise.objects.filter(
            exercisestandard__standard__standardid__in=standards
        ).distinct()

        if not exercises.exists():
            return Response(
                {"error": "No exercises found for the given criteria."},
                status=status.HTTP_404_NOT_FOUND
            )

        exercises = exercises.order_by('?')[:num_exercises]

        # Create assessment
        assessment = Assessment.objects.create(
            title=f"Generated Assessment - {course.name}",
            course=course,
            created_by=request.user,
            is_generated=True
        )

        # Calculate points per exercise
        points_per_exercise = round(100 / num_exercises)

        # Create assessment exercises
        for index, exercise in enumerate(exercises):
            AssessmentExercise.objects.create(
                assessment=assessment,
                exercise=exercise,
                order=index,
                points=points_per_exercise
            )

        return Response(
            AssessmentSerializer(assessment).data,
            status=status.HTTP_201_CREATED
        )