from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import AssessmentViewSet, CourseViewSet

router = DefaultRouter()
router.register(r'assessments', AssessmentViewSet, basename='assessment')
router.register(r'course', CourseViewSet, basename='courses')


urlpatterns = [
    path('', include(router.urls)),
]