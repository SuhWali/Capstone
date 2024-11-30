from django.shortcuts import render

# Create your views here.

from rest_framework import viewsets, mixins
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from course.models import CourseEnrollment, Course, Assessment, AssessmentExercise
from course.serializers import AssessmentSerializerSecond, AssessmentExerciseSerializer
from .serializers import CourseEnrollmentSerializer, ExerciseRecommendationSerializer, ExampleRecommendationSerializer, DocumentRecommendationSerializer

from instructor.models import Domain, Document, ExerciseStandard, Exercise, Example
from instructor.serializers import DomainSerializer, DocumentSerializer

from rest_framework.decorators import action


class StudentEnrollmentViewSet(mixins.ListModelMixin,
                            mixins.RetrieveModelMixin,
                            viewsets.GenericViewSet):
    
    """
    ViewSet for viewing course enrollments.
    This ViewSet provides 'list' and 'retrieve' actions.
    """

    serializer_class = CourseEnrollmentSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return CourseEnrollment.objects.filter(  # pylint: disable=E1101
            student=self.request.user,
            is_active=True
        ).select_related('course', 'course__instructor', 'course__grade')
        

    
    @action(detail=False, methods=['GET'])
    def my_domains(self, request):
        course_id = request.query_params.get('course')

        if not course_id:
            return Response({"error": "Grade ID is required"}, status=400)
            
        try:
            course = Course.objects.get(
                students=request.user,
                id=course_id
            )
        except Course.DoesNotExist:
            return Response({"error": "Not authorized for this course"}, status=403)
        
            
        domains = Domain.objects.filter(grade=course.grade) # pylint: disable=E1101
        serializer = DomainSerializer(domains, many=True)
        return Response(serializer.data)
    

    @action(detail=False, methods=['GET'])
    def domain_documents(self, request, pk=None):
        print("we are here",pk)

        domain_id = request.query_params.get('domain')
        
        try:
            # Verify the student has access to this domain through their course
            domain = Domain.objects.get(domainid=domain_id)
            course = Course.objects.filter(
                students=request.user,
                grade=domain.grade
            ).first()
            
            if not course:
                return Response({"error": "Not authorized for this domain"}, status=403)
            
            # Get documents for this domain
            documents = Document.objects.filter(domain=domain)
            serializer = DocumentSerializer(documents, many=True)
            return Response(serializer.data)
            
        except Domain.DoesNotExist:
            return Response({"error": "Domain not found"}, status=404)
        



    @action(detail=True, methods=['GET'])
    def assessments(self, request, pk=None):
        """Get assessments for a course"""
        print(request.user)

        try:
            course = Course.objects.get(
                # studentss=request.user,
                id=pk
            )
           
            assessments = Assessment.objects.filter(course=course)
            serializer = AssessmentSerializerSecond(assessments, many=True)
            return Response(serializer.data)
        except Course.DoesNotExist:
            return Response({"error": "Course not found"}, status=404)

    @action(detail=True, methods=['GET'])
    def exercises(self, request, pk=None):
        """Get exercises for an assessment"""
        try:
            assessment = Assessment.objects.get(pk=pk)
            # Verify student has access to this assessment's course
            # if not assessment.course.students.filter(id=request.user.id).exists():
            #     return Response({"error": "Not authorized"}, status=403)
                
            exercises = AssessmentExercise.objects.filter(assessment=assessment)
            serializer = AssessmentExerciseSerializer(exercises, many=True)
            return Response(serializer.data)
        except Assessment.DoesNotExist:
            return Response({"error": "Assessment not found"}, status=404)
        



    @action(detail=True, methods=['GET'])
    def recommendations(self, request, pk=None):
        """Get recommendations for an exercise"""
        try:
            exercise = Exercise.objects.get(exercise_id=pk)
            
            # Get standards for this exercise
            exercise_standards = ExerciseStandard.objects.filter(
                exercise=exercise
            ).select_related('standard')
            
            standard_ids = [es.standard_id for es in exercise_standards]
            
            # Get similar exercises with their standards
            similar_exercises = Exercise.objects.filter(
                exercisestandard__standard_id__in=standard_ids
            ).exclude(exercise_id=exercise.exercise_id).distinct().prefetch_related('exercisestandard_set')[:5]
            
            # Get similar examples with their standards
            similar_examples = Example.objects.filter(
                examplestandard__standard_id__in=standard_ids
            ).distinct().prefetch_related('examplestandard_set')[:5]
            
            # Get related documents with their standards
            related_documents = Document.objects.filter(
                documentstandard__standard_id__in=standard_ids
            ).distinct().prefetch_related('documentstandard_set')[:5]
            
            return Response({
                'exercises': ExerciseRecommendationSerializer(similar_exercises, many=True).data,
                'examples': ExampleRecommendationSerializer(similar_examples, many=True).data,
                'documents': DocumentRecommendationSerializer(related_documents, many=True).data
            })
            
        except Exercise.DoesNotExist:
            return Response({"error": "Exercise not found"}, status=404)
