
from django.core.exceptions import PermissionDenied
from django.utils.timezone import now
from django.contrib.auth import get_user_model

from rest_framework import viewsets, permissions, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser

from random import choice

from . serializers import DocumentSerializer, GradeSerializer, DomainSerializer

from .models import InstructorGrade, Domain, Document, Grade



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
    
    @action(detail=True, methods=['GET'])
    def domain_detail(self, request, pk=None):
        """
        Retrieve a specific domain by its ID, ensuring the instructor has access to it.
        """
        try:
            # Fetch the domain
            domain = Domain.objects.get(domainid=pk)  # pylint: disable=E1101
        except Domain.DoesNotExist:   # pylint: disable=E1101
            return Response({"error": "Domain not found"}, status=404)

        # Check if the instructor has access to the grade associated with the domain
        if not InstructorGrade.objects.filter(instructor=request.user, grade_id=domain.gradeid.gradeid).exists():  # pylint: disable=E1101
            return Response({"error": "Not authorized to access this domain"}, status=403)

        # Serialize and return the domain data
        serializer = DomainSerializer(domain)
        return Response(serializer.data)


class DocumentViewSet(viewsets.ModelViewSet):
    serializer_class = DocumentSerializer
    permission_classes = [permissions.IsAuthenticated]
    parser_classes = [MultiPartParser, FormParser]

    def get_queryset(self):
        if self.request.user.is_superuser:
            return Document.objects.all()   # pylint: disable=E1101
        
        # Get the grades this instructor is assigned to
        instructor_grades = InstructorGrade.objects.filter( # pylint: disable=E1101
            instructor=self.request.user
        ).values_list('grade', flat=True)
        
        # Return documents for domains that belong to these grades
        # and were uploaded by this instructor
        return Document.objects.filter( # pylint: disable=E1101
            instructor=self.request.user,
            domain__gradeid__in=instructor_grades
        )

    def perform_create(self, serializer):
        serializer.save(instructor=self.request.user)

    def create(self, request, *args, **kwargs):
        data = request.data.copy()
        if 'file' not in request.FILES:
            return Response(
                {'error': 'No file was submitted'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        if 'domain' not in data:
            return Response(
                {'error': 'Domain must be specified'},
                status=status.HTTP_400_BAD_REQUEST
            )

        serializer = self.get_serializer(data=data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(
            serializer.data,
            status=status.HTTP_201_CREATED,
            headers=headers
        )

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        if instance.instructor != request.user and not request.user.is_superuser:
            raise PermissionDenied("You don't have permission to edit this document")
        
        # Validate the new domain if it's being changed
        if 'domain' in request.data:
            has_permission = InstructorGrade.objects.filter(    # pylint: disable=E1101
                instructor=request.user,
                grade=Domain.objects.get(domainid=request.data['domain']).gradeid   # pylint: disable=E1101
            ).exists()
            if not has_permission and not request.user.is_superuser:
                raise PermissionDenied("You don't have permission to move documents to this domain")
                
        return super().update(request, *args, **kwargs)

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        if instance.instructor != request.user and not request.user.is_superuser:
            raise PermissionDenied("You don't have permission to delete this document")
        return super().destroy(request, *args, **kwargs)

    @action(detail=False, methods=['GET'])
    def available_domains(self, request):
        """
        Get list of domains available to the instructor for uploading documents
        """
        if request.user.is_superuser:
            domains = Domain.objects.all()  # pylint: disable=E1101
        else:
            instructor_grades = InstructorGrade.objects.filter( # pylint: disable=E1101
                instructor=request.user
            ).values_list('grade', flat=True)
            domains = Domain.objects.filter(gradeid__in=instructor_grades)  # pylint: disable=E1101
            
        serializer = DomainSerializer(domains, many=True)
        return Response(serializer.data)

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