from rest_framework import serializers

from .models import Grade, Domain, Document

class GradeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Grade
        fields = '__all__'

class DomainSerializer(serializers.ModelSerializer):
    grade_name = serializers.CharField(source='grade.name', read_only=True)
    
    class Meta:
        model = Domain
        fields = ['id', 'name', 'grade', 'grade_name', 'description']

class DocumentSerializer(serializers.ModelSerializer):
    domain_name = serializers.CharField(source='domain.name', read_only=True)
    uploaded_by_name = serializers.CharField(source='uploaded_by.username', read_only=True)
    
    class Meta:
        model = Document
        fields = ['id', 'title', 'file', 'domain', 'domain_name', 
                 'uploaded_by', 'uploaded_by_name', 'uploaded_at', 'description']
