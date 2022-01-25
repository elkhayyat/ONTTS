from projects import views
from rest_framework.routers import DefaultRouter
from django.urls import path, include

app_name = 'projects'

router = DefaultRouter()
router.register(r'projects', views.ProjectViewSet)
router.register(r'tasks', views.ProjectTaskViewSet)
router.register(r'members', views.ProjectMemberViewSet)
router.register(r'times', views.ProjectTimeViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('time/start/', views.StartTime.as_view(), name='start'),
    path('time/stop/', views.StopTime.as_view(), name='stop'),
    path('opened/tasks/', views.OpenedTasks.as_view(), name='opened_tasks'),
    
]
