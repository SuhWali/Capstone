from django.shortcuts import render

# Create your views here.

from rest_framework import viewsets, permissions
from rest_framework.decorators import action
from rest_framework.response import Response

from . serializers import DocumentSerializer, GradeSerializer, DomainSerializer
from .models import InstructorGrade, Domain, Document

class InstructorViewSet(viewsets.ViewSet):
    permission_classes = [permissions.IsAuthenticated]

    @action(detail=False, methods=['GET'])
    def my_grades(self, request):
        instructor_grades = InstructorGrade.objects.filter(instructor=request.user)
        grades = [ig.grade for ig in instructor_grades]
        serializer = GradeSerializer(grades, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['GET'])
    def my_domains(self, request):
        instructor_grades = InstructorGrade.objects.filter(instructor=request.user)
        domains = Domain.objects.filter(grade__in=[ig.grade for ig in instructor_grades])
        serializer = DomainSerializer(domains, many=True)
        return Response(serializer.data)

class DocumentViewSet(viewsets.ModelViewSet):
    serializer_class = DocumentSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        # Only show documents for domains in instructor's grades
        instructor_grades = InstructorGrade.objects.filter(instructor=self.request.user)
        return Document.objects.filter(
            domain__grade__in=[ig.grade for ig in instructor_grades]
        )

    def perform_create(self, serializer):
        serializer.save(uploaded_by=self.request.user)
