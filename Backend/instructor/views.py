from django.shortcuts import render

# Create your views here.

from rest_framework import viewsets, permissions
from rest_framework.decorators import action
from rest_framework.response import Response


from random import choice
from django.utils.timezone import now

from . serializers import DocumentSerializer, GradeSerializer, DomainSerializer
from .models import InstructorGrade, Domain, Document, Grade

from django.contrib.auth import get_user_model

User = get_user_model()

class InstructorViewSet(viewsets.ViewSet):
    permission_classes = [permissions.IsAuthenticated]

    @action(detail=False, methods=['GET'])
    def my_grades(self, request):
        instructor_grades = InstructorGrade.objects.filter(instructor=request.user) # pylint: disable=E1101
        grades = [ig.grade for ig in instructor_grades]
        serializer = GradeSerializer(grades, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['GET'])
    def my_domains(self, request):
        grade_id = request.query_params.get('grade')
        if not grade_id:
            return Response({"error": "Grade ID is required"}, status=400)
            
        instructor_grades = InstructorGrade.objects.filter(instructor=request.user, grade_id=grade_id) # pylint: disable=E1101
        if not instructor_grades.exists():
            return Response({"error": "Not authorized for this grade"}, status=403)
            
        domains = Domain.objects.filter(gradeid=grade_id) # pylint: disable=E1101
        serializer = DomainSerializer(domains, many=True)
        return Response(serializer.data)

class DocumentViewSet(viewsets.ModelViewSet):
    serializer_class = DocumentSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        # Only show documents for domains in instructor's grades
        instructor_grades = InstructorGrade.objects.filter(instructor=self.request.user) # pylint: disable=E1101
        return Document.objects.filter( # pylint: disable=E1101
            domain__grade__in=[ig.grade for ig in instructor_grades]
        ) 

    def perform_create(self, serializer):
        serializer.save(uploaded_by=self.request.user)




class GradeAssignmentViewSet(viewsets.ViewSet):
    # permission_classes = [IsAdminUser]  # Only admins can assign grades

    @action(detail=False, methods=['POST'])
    def assign_grades(self, request):
        """
        Custom action to assign random grades to all instructors.
        """
        # Step 1: Filter instructors
        instructors = User.objects.filter(groups__name='instructor')

        # Step 2: Get all grade IDs
        grade_ids = list(Grade.objects.values_list('gradeid', flat=True))  #  pylint: disable=E1101

        # Step 3: Assign random grades to instructors
        assigned_count = 0
        for instructor in instructors:
            random_grade_id = choice(grade_ids)
            grade = Grade.objects.get(gradeid=random_grade_id) # pylint: disable=E1101
            _, created = InstructorGrade.objects.get_or_create(   # pylint: disable=E1101
                instructor=instructor,
                grade=grade,
                defaults={'assigned_at': now()}
            )
            if created:
                assigned_count += 1

        # Return a success response
        return Response({'message': f'Grades assigned to {assigned_count} instructors successfully.'})