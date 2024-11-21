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
