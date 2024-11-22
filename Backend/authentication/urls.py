from django.urls import path, include

from . import views
# from rest_framework.authtoken.views import obtain_auth_token
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)

from .views import UserRolesView

# from .views import RegistrationView, UserProfileView

urlpatterns = [
    # Define your app's URLs here
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('auth/', include('dj_rest_auth.urls')),
    path('auth/registration/', include('dj_rest_auth.registration.urls')),  # Registration

    path('user-roles/', UserRolesView.as_view(), name='user_roles'),


]
