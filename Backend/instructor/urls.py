from rest_framework.routers import DefaultRouter
from django.urls import path, include

from .views import InstructorViewSet, DocumentViewSet, GradeAssignmentViewSet

router = DefaultRouter()
router.register(r'instructor', InstructorViewSet, basename='instructor')
router.register(r'documents', DocumentViewSet, basename='document')
router.register(r'grade-assignment',  GradeAssignmentViewSet, basename='grade-assignment')


urlpatterns = [
    path('', include(router.urls)),
]