from rest_framework.routers import DefaultRouter
from django.urls import path, include

from .views import InstructorViewSet, DocumentViewSet

router = DefaultRouter()
router.register(r'instructor', InstructorViewSet, basename='instructor')
router.register(r'documents', DocumentViewSet, basename='document')

urlpatterns = [
    path('', include(router.urls)),
]