from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import StudentEnrollmentViewSet

router = DefaultRouter()
router.register(r'enrollments', StudentEnrollmentViewSet, basename='student-enrollment')

urlpatterns = [
    path('', include(router.urls)),
]