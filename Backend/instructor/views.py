
from django.core.exceptions import PermissionDenied
from django.utils.timezone import now
from django.contrib.auth import get_user_model

from rest_framework import viewsets, permissions, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser

from random import choice

import logging

from . serializers import DocumentSerializer, GradeSerializer, DomainSerializer, ClusterSerializer, StandardSerializer

from .models import InstructorGrade, Domain, Document, Grade, Clusters, Domain, Standards
from course.models import Course

from .utils.utils import DocumentAnalyzer

from .utils.content_processor import ContentProcessor

from course.models import Course



User = get_user_model()

class InstructorViewSet(viewsets.ViewSet):
    permission_classes = [permissions.IsAuthenticated]

    # @action(detail=False, methods=['GET'])
    # def my_grades(self, request):
    #     instructor_grades = InstructorGrade.objects.filter(instructor=request.user) # pylint: disable=E1101
    #     grades = [ig.grade for ig in instructor_grades]
    #     serializer = GradeSerializer(grades, many=True)
    #     return Response(serializer.data)



    @action(detail=False, methods=['GET'])
    def my_grades(self, request):
        # Instead of querying InstructorGrade, we'll query Course
        instructor_courses = Course.objects.filter(instructor=request.user)
        # Extract the grades from the courses
        grades = [course.grade for course in instructor_courses]
        # Remove duplicates if an instructor teaches multiple courses in the same grade
        grades = list(dict.fromkeys(grades))
        serializer = GradeSerializer(grades, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['GET'])
    def my_domains(self, request):
        grade_id = request.query_params.get('grade')
        if not grade_id:
            return Response({"error": "Grade ID is required"}, status=400)
            
        instructor_grades = Course.objects.filter(instructor=request.user, grade_id=grade_id) # pylint: disable=E1101
        if not instructor_grades.exists():
            return Response({"error": "Not authorized for this grade"}, status=403)
            
        domains = Domain.objects.filter(grade=grade_id) # pylint: disable=E1101
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
        if not InstructorGrade.objects.filter(instructor=request.user, grade_id=domain.grade.gradeid).exists():  # pylint: disable=E1101
            return Response({"error": "Not authorized to access this domain"}, status=403)

        # Serialize and return the domain data
        serializer = DomainSerializer(domain)
        return Response(serializer.data)
    

    @action(detail=False, methods=['GET'])
    def my_clusters(self, request):
        domain_id = request.query_params.get('domain')
        if not domain_id:
            return Response({"error": "Domain ID is required"}, status=400)
            
        # instructor_grades = InstructorGrade.objects.filter(instructor=request.user, grade_id=grade_id) # pylint: disable=E1101
        # if not instructor_grades.exists():
        #     return Response({"error": "Not authorized for this grade"}, status=403)
            
        clusters = Clusters.objects.filter(domainid=domain_id) # pylint: disable=E1101
        serializer = ClusterSerializer(clusters, many=True)
        return Response(serializer.data)


    @action(detail=False, methods=['GET'])
    def my_standards(self, request):
        cluster_id = request.query_params.get('cluster')
        if not cluster_id:
            return Response({"error": "Domain ID is required"}, status=400)
            
        # instructor_grades = InstructorGrade.objects.filter(instructor=request.user, grade_id=grade_id) # pylint: disable=E1101
        # if not instructor_grades.exists():
        #     return Response({"error": "Not authorized for this grade"}, status=403)
            
        clusters = Standards.objects.filter(clusterid=cluster_id) # pylint: disable=E1101
        serializer = StandardSerializer(clusters, many=True)
        return Response(serializer.data)


logger = logging.getLogger(__name__)

class DocumentViewSet(viewsets.ModelViewSet):
    serializer_class = DocumentSerializer
    permission_classes = [permissions.IsAuthenticated]
    parser_classes = [MultiPartParser, FormParser]

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.analyzer = DocumentAnalyzer()
        self.process_nli = ContentProcessor()


    def get_queryset(self):
        if self.request.user.is_superuser:
            return Document.objects.all()   # pylint: disable=E1101
        
        instructor_grades = Course.objects.filter( # pylint: disable=E1101
            instructor=self.request.user
        ).values_list('grade', flat=True)
        
        return Document.objects.filter( # pylint: disable=E1101
            instructor=self.request.user,
            domain__grade__in=instructor_grades
        )

    def perform_create(self, serializer):
        document = serializer.save(instructor=self.request.user)
        
        # Trigger document analysis if it's a PDF
        if document.file.name.lower().endswith('.pdf'):
            try:
                logger.info(f"Starting analysis for document: {document.file.name}")
                self.analyzer.analyze_document(document)
                logger.info(f"Analysis completed for document: {document.file.name}")
                
                logger.info(f"NLI analysis for document: {document.file.name}")
                self.process_nli.process_document_content(document)
                logger.info(f"NLI completed for document: {document.file.name}")
            except Exception as e:
                logger.error(f"Error during document analysis: {str(e)}")
                # Note: We don't raise the exception here to avoid failing the upload
                # The analysis can be retried later if needed

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
        
        if 'domain' in request.data:
            has_permission = InstructorGrade.objects.filter(    # pylint: disable=E1101
                instructor=request.user,
                grade=Domain.objects.get(domainid=request.data['domain']).grade   # pylint: disable=E1101
            ).exists()
            if not has_permission and not request.user.is_superuser:
                raise PermissionDenied("You don't have permission to move documents to this domain")
        
        response = super().update(request, *args, **kwargs)
        
        # Re-analyze if file was updated and is a PDF
        if 'file' in request.FILES and request.FILES['file'].name.lower().endswith('.pdf'):
            try:
                logger.info(f"Starting re-analysis for updated document: {instance.file.name}")
                self.analyzer.analyze_document(instance)
                logger.info(f"Re-analysis completed for document: {instance.file.name}")
            except Exception as e:
                logger.error(f"Error during document re-analysis: {str(e)}")
        
        return response

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        if instance.instructor != request.user and not request.user.is_superuser:
            raise PermissionDenied("You don't have permission to delete this document")
        return super().destroy(request, *args, **kwargs)

    @action(detail=False, methods=['GET'])
    def available_domains(self, request):
        if request.user.is_superuser:
            domains = Domain.objects.all()  # pylint: disable=E1101
        else:
            instructor_grades = InstructorGrade.objects.filter( # pylint: disable=E1101
                instructor=request.user
            ).values_list('grade', flat=True)
            domains = Domain.objects.filter(grade__in=instructor_grades)  # pylint: disable=E1101
            
        serializer = DomainSerializer(domains, many=True)
        return Response(serializer.data)

    @action(detail=True, methods=['POST'])
    def analyze(self, request, pk=None):
        """Analyze document and store both concept and exercise results."""
        document = self.get_object()
        
        try:
            analyzer = DocumentAnalyzer()
            results = analyzer.analyze_document(document)
            
            return Response({
                'status': 'success',
                'message': 'Analysis completed',
                'paths': results['paths'],
                'results': {
                    'concepts': results['concepts'],
                    'exercises': results['exercises']
                }
            })
        except Exception as e:
            return Response({
                'status': 'error',
                'message': str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @action(detail=True, methods=['GET'])
    def analysis(self, request, pk=None):
        """Get the analysis results."""
        document = self.get_object()
        analysis_type = request.query_params.get('type', 'both')
        
        if analysis_type not in ['both', 'concepts', 'exercises']:
            return Response({
                'status': 'error',
                'message': 'Invalid analysis type. Must be one of: both, concepts, exercises'
            }, status=status.HTTP_400_BAD_REQUEST)
        
        analyzer = DocumentAnalyzer()
        result = analyzer.get_analysis_result(document, analysis_type)
        
        if result:
            return Response({
                'status': 'success',
                'result': result
            })
        else:
            return Response({
                'status': 'not_found',
                'message': 'No analysis found for this document'
            }, status=status.HTTP_404_NOT_FOUND)
    
    @action(detail=True, methods=['POST'])
    def reanalyze(self, request, pk=None):
        """Manually trigger re-analysis of a document."""
        document = self.get_object()
        
        if not document.file.name.lower().endswith('.pdf'):
            return Response(
                {'error': 'Analysis is only available for PDF documents'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            result, analysis_path = self.analyzer.analyze_document(document)
            return Response({
                'message': 'Analysis completed successfully',
                'result': result
            })
        except Exception as e:
            logger.error(f"Error during re-analysis: {str(e)}")
            return Response(
                {'error': f'Error during analysis: {str(e)}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
        

    @action(detail=True, methods=['POST'])
    def process_content(self, request, pk=None):
        """Process document content and populate related tables."""
        document = self.get_object()
        
        try:
            processor = ContentProcessor()
            results = processor.process_document_content(document)
            
            return Response({
                'status': 'success',
                'results': results
            })
        except Exception as e:
            return Response({
                'status': 'error',
                'message': str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @action(detail=True, methods=['GET'])
    def content_summary(self, request, pk=None):
        """Get summary of document content and relationships."""
        document = self.get_object()
        
        summary = {
            'standards': [{
                'id': rel.standard.id,
                'description': rel.standard.description,
                'score': rel.confidence_score,
                # 'relationship': rel.relationship_type
            } for rel in document.documentstandard_set.all()],
            
            'exercises': [{
                'id': exercise.exercise_id,
                'content': exercise.content[:100] + '...',
                'standards': [{
                    'id': rel.standard.id,
                    'score': rel.confidence_score
                } for rel in exercise.exercisestandard_set.all()]
            } for exercise in document.exercises.all()],
            
            'examples': [{
                'id': example.example_id,
                'content': example.content[:100] + '...',
                'standards': [{
                    'id': rel.standard.id,
                    'score': rel.confidence_score
                } for rel in example.examplestandard_set.all()]
            } for example in document.examples.all()]
        }
        
        return Response(summary)


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