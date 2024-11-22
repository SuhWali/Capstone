from rest_framework import serializers
from django.contrib.auth.models import Group, Permission

class RoleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Group
        fields = ['name']

class PermissionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Permission
        fields = ['codename', 'name']

class UserRolesSerializer(serializers.Serializer):
    roles = RoleSerializer(many=True, source='groups')
    permissions = PermissionSerializer(many=True, source='user_permissions')


from dj_rest_auth.registration.serializers import RegisterSerializer
from rest_framework import serializers

class CustomRegisterSerializer(RegisterSerializer):
    first_name = serializers.CharField(max_length=30, required=True)
    last_name = serializers.CharField(max_length=30, required=True)

    def save(self, request):
        user = super().save(request)
        user.first_name = self.validated_data['first_name']
        user.last_name = self.validated_data['last_name']
        user.save()
        return user
