# from django.shortcuts import render
# from django.http import HttpResponse


from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.contrib.auth.models import Group, Permission


class UserRolesView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request):
        user = request.user
        roles = user.groups.values_list(
            'name', flat=True)  # List of role names
        # permissions = user.get_user_permissions()  # List of permission codenames
        return Response({
            'roles': roles,
        })