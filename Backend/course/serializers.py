from rest_framework import serializers
from .models import Assessment, AssessmentExercise
from django.core.validators import MinValueValidator


class AssessmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Assessment
        fields = ['id', 'title', 'course',  
                 'is_generated', 
                 'created_at', 'updated_at']
        read_only_fields = ['created_by']

    def create(self, validated_data):
        validated_data['created_by'] = self.context['request'].user
        return super().create(validated_data)

class AssessmentExerciseSerializer(serializers.ModelSerializer):
    class Meta:
        model = AssessmentExercise
        fields = ['id', 'assessment', 'exercise',  'order']




class GenerateAssessmentSerializer(serializers.Serializer):
    course_id = serializers.IntegerField(required=True)
    domain_id = serializers.IntegerField(required=False)
    cluster_id = serializers.IntegerField(required=False)
    num_exercises = serializers.IntegerField(required=False, default=10, validators=[MinValueValidator(1)])

    def validate(self, data):
        if not data.get('domain_id') and not data.get('cluster_id'):
            raise serializers.ValidationError("Either 'domain_id' or 'cluster_id' must be provided.")
        return data