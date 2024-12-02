from rest_framework import serializers
from django.core.validators import MinValueValidator
from django.shortcuts import get_object_or_404
from .models import Assessment, AssessmentExercise, Course
from instructor.models import Exercise, Standards
from instructor.serializers import ExerciseSerializer
from django.db.models import Q


class AssessmentSerializer(serializers.ModelSerializer):
    domain_id = serializers.IntegerField(
        write_only=True, required=False, allow_null=True)
    cluster_id = serializers.IntegerField(
        write_only=True, required=False, allow_null=True)
    standard_id = serializers.IntegerField(
        write_only=True, required=False, allow_null=True)
    num_exercises = serializers.IntegerField(
        write_only=True,
        default=10,
        validators=[MinValueValidator(1)]
    )
    exercise_count = serializers.IntegerField(
        read_only=True, source='assessmentexercise_set.count')

    class Meta:
        model = Assessment
        fields = ['id', 'title', 'course', 'is_generated', 'created_at', 'updated_at',
                  'domain_id', 'cluster_id', 'standard_id', 'num_exercises', 'exercise_count']
        read_only_fields = ['created_by', 'is_generated']

    def validate(self, data):
        filters = ['domain_id', 'cluster_id', 'standard_id']
        if not any(data.get(filter_field) for filter_field in filters):
            raise serializers.ValidationError(
                "At least one filter (domain_id, cluster_id, or standard_id) must be provided."
            )
        return data

    def to_internal_value(self, data):
        # Make a mutable copy if it's a QueryDict (DRF browser interface)
        if hasattr(data, 'copy'):
            data = data.copy()
        # If it's a dict (like from Angular), convert it to a mutable dict
        else:
            data = dict(data)

        # Convert empty strings to None
        for field in ['domain_id', 'cluster_id', 'standard_id']:
            if field in data and data[field] == "":
                data[field] = None

        return super().to_internal_value(data)


    def create(self, validated_data):
        # Extract generation parameters
        domain_id = validated_data.pop('domain_id', None)
        cluster_id = validated_data.pop('cluster_id', None)
        standard_id = validated_data.pop('standard_id', None)
        num_exercises = validated_data.pop('num_exercises', 10)
        user = self.context['request'].user

        # Validate course ownership
        course = get_object_or_404(
            Course,
            grade=validated_data['course'].grade,
            instructor=user
        )

        # Build standards query
        standards_query = Q()
        if standard_id:
            standards_query |= Q(standardid=standard_id)
        if cluster_id:
            standards_query |= Q(clusterid=cluster_id)
        if domain_id:
            standards_query |= Q(clusterid__domainid=domain_id)

        # Get standards
        standards = Standards.objects.filter(standards_query).values_list('standardid', flat=True)

        if not standards:
            raise serializers.ValidationError("No standards found matching the criteria.")

        # Get exercise IDs
        exercise_ids = (Exercise.objects
                        .filter(exercisestandard__standard__standardid__in=standards)
                        .values_list('exercise_id', flat=True)
                        .distinct())

        if not exercise_ids:
            raise serializers.ValidationError("No exercises found matching the criteria.")

        # Convert exercise_ids to a list
        exercise_ids = list(exercise_ids)

        # Adjust num_exercises if there are fewer exercises than requested
        num_exercises = min(len(exercise_ids), num_exercises)

        # Randomly select exercise IDs
        import random
        selected_exercise_ids = random.sample(exercise_ids, num_exercises)

        # Fetch Exercise objects based on the selected IDs
        exercises = Exercise.objects.filter(exercise_id__in=selected_exercise_ids)

        # Create assessment
        assessment = Assessment.objects.create(
            title=validated_data.get('title', f"Generated Assessment - {course.name}"),
            course=course,
            created_by=user,
            is_generated=True
        )

        # Create assessment exercises
        AssessmentExercise.objects.bulk_create([
            AssessmentExercise(
                assessment=assessment,
                exercise=exercise,
                order=index
            ) for index, exercise in enumerate(exercises)
        ])

        return assessment


class CourseSerializer(serializers.ModelSerializer):

    class Meta:
        model = Course
        fields = '__all__'



class AssessmentExerciseSerializer(serializers.ModelSerializer):
    exercise = ExerciseSerializer()
    
    class Meta:
        model = AssessmentExercise
        fields = ['id', 'assessment', 'exercise', 'order']

class AssessmentSerializerSecond(serializers.ModelSerializer):
    class Meta:
        model = Assessment
        fields = ['id', 'title', 'course', 'created_by', 'is_generated', 
                 'created_at', 'updated_at']

