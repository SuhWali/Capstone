from rest_framework import serializers

from .models import Grade, Domain, Document, InstructorGrade


class GradeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Grade
        fields = '__all__'


class DomainSerializer(serializers.ModelSerializer):
    grade_name = serializers.CharField(
        source='grade.gradename', read_only=True)

    class Meta:
        model = Domain
        fields = ['domainid', 'grade',
                'grade_name', 'domain_abb', 'domainname']


class DocumentSerializer(serializers.ModelSerializer):
    instructor_name = serializers.CharField(source='instructor.username', read_only=True)
    domain_name = serializers.CharField(source='domain.domainname', read_only=True)
    domain_grade = serializers.CharField(source='domain.grade.gradename', read_only=True)
    upload_date = serializers.DateTimeField(read_only=True)
    file_url = serializers.SerializerMethodField()
    
    class Meta:
        model = Document
        fields = [
            'id',
            'instructor',
            'instructor_name',
            'domain',
            'domain_name',
            'domain_grade',
            'title',
            'description',
            'upload_date',
            'file',
            'file_url'
        ]
        read_only_fields = ['instructor', 'upload_date']

    def get_file_url(self, obj):
        if obj.file:
            request = self.context.get('request')
            if request:
                return request.build_absolute_uri(obj.file.url)
        return None
    
    def validate_domain(self, value):
        """
        Check that the instructor has permission to upload to this domain's grade
        """
        user = self.context['request'].user
        if not user.is_superuser:  # Skip validation for superusers
            # Check if the instructor is assigned to this domain's grade
            has_permission = InstructorGrade.objects.filter(    #  pylint: disable=E1101
                instructor=user,
                grade=value.gradeid
            ).exists()
            if not has_permission:
                raise serializers.ValidationError(
                    "You don't have permission to upload documents to this domain"
                )
        return value
