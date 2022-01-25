import imp
from rest_framework.routers import DefaultRouter
from django.urls import path, include
from accounts import views

app_name = 'accounts'
router = DefaultRouter()
router.register(r'users', views.UserViewSet)
urlpatterns = [
    path('', include(router.urls)),
    path('register/', views.RegisterAPIView.as_view(), name='register'),
    path('login/', views.LoginAPIView.as_view(), name='login'),
]
