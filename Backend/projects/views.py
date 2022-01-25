from os import stat
from django.shortcuts import get_object_or_404
from django.utils.timezone import now
from projects import models
from rest_framework import viewsets, views, status, response, generics
from projects.models import Project, ProjectMember, ProjectTask, ProjectTime
from projects import serializers
from rest_framework.views import APIView
from rest_framework import authentication, permissions
from django.utils.translation import gettext as _
# Create your views here.


# Project ViewSet
class ProjectViewSet(viewsets.ModelViewSet):
    authentication_classes = [authentication.TokenAuthentication]
    serializer_class = serializers.ProjectSerializer
    queryset = Project.objects.all()

    def get_queryset(self):
        if self.request.user.is_anonymous:
            queryset = Project.objects.none()
        if self.request.user.is_superuser:
            queryset = Project.objects.all()
        else:
            prequery = self.request.user.projectmember_set.all()
            queryset = Project.objects.filter(members__in=prequery)
        return queryset


# Project Memeber ViewSet
class ProjectMemberViewSet(viewsets.ModelViewSet):
    authentication_classes = [authentication.TokenAuthentication]
    serializer_class = serializers.ProjectMemberSerializer
    queryset = ProjectMember.objects.all()

    def get_queryset(self):
        project_id = self.request.GET.get('project')
        if self.request.user.is_superuser:
            projects = Project.objects.all()
        else:
            projects = self.request.user.projects
        queryset = ProjectMember.objects.filter(project__in=projects)
        if project_id:
            queryset = queryset.filter(project__id=project_id)
        return queryset


# Project Task ViewSet
class ProjectTaskViewSet(viewsets.ModelViewSet):
    authentication_classes = [authentication.TokenAuthentication]
    serializer_class = serializers.ProjectTaskSerializer
    queryset = ProjectTask.objects.all()

    def get_queryset(self):
        project_id = self.request.GET.get('project_id')
        user_id = self.request.GET.get('user')
        queryset = ProjectTask.objects.all()
        if project_id:
            queryset = queryset.filter(project__id=project_id)
        if user_id:
            queryset = queryset.filter(user__id=user_id)
        return queryset


# Project Time ViewSet
class ProjectTimeViewSet(viewsets.ModelViewSet):
    authentication_classes = [authentication.TokenAuthentication]
    serializer_class = serializers.ProjectTimeSerializer
    queryset = ProjectTime.objects.all()

    def get_queryset(self):
        project_id = self.request.GET.get('project')
        user_id = self.request.GET.get('user')
        task_id = self.request.GET.get('task')
        queryset = ProjectTime.objects.all()
        if project_id:
            queryset = queryset.filter(project__id=project_id)
        if user_id:
            queryset = queryset.filter(user__id=user_id)
        if task_id:
            queryset = queryset.filter(task__id=task_id)
        return queryset


# Start Time
class StartTime(generics.GenericAPIView):
    authentication_classes = [authentication.TokenAuthentication]

    def post(self, request):
        if request.user.is_anonymous:
            return response.Response(status=status.HTTP_401_UNAUTHORIZED)
        if request.user.has_opened_tasks():
            return response.Response({
                'status': 'Error',
                'result': _('You have already started time for a task/project. Please stop it first')
            })
        else:
            form_data = self.request.data
            project_id = form_data.get('project_id')
            task_id = form_data.get('task_id')
            project_time_object = ProjectTime()
            project_time_object.user = request.user
            if project_id:
                project = get_object_or_404(Project, id=project_id)
                project_time_object.project = project
            if task_id:
                task = get_object_or_404(ProjectTask, id=task_id)
                project_time_object.task = task
            project_time_object.start_at = now
            project_time_object.save()
            serializer = serializers.ProjectTimeSerializer(project_time_object)
            return response.Response(serializer, status=status.HTTP_201_CREATED)


# Stop Time
class StopTime(generics.GenericAPIView):
    def post(self, request):

        form_data = self.request.data
        object_id = form_data.get('time_id')
        if request.user.is_anonymous:
            return response.Response(status=status.HTTP_401_UNAUTHORIZED)

        try:
            time_object = ProjectTime.objects.get(id=object_id)
            if time_object.end_at:
                return response.Response(
                    {
                        'status': 'Error',
                        'message': 'This already stopped before',
                    }, status=status.HTTP_403_FORBIDDEN
                )
            elif time_object.user != request.user:
                return response.Response(
                    {
                        'status': 'Error',
                        'message': 'You aren\'t the owner of this object',
                    }, status=status.HTTP_401_UNAUTHORIZED
                )
            else:
                time_object.end_time()
                serializer = serializers.ProjectTimeSerializer(time_object)
                return response.Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            print(e)
            return response.Response(e)


class OpenedTasks(generics.GenericAPIView):
    serializer_class = serializers.ProjectTimeSerializer

    def post(self, request):
        if request.user.is_anonymous:
            print(self.request.headers)
            return response.Response(status=status.HTTP_401_UNAUTHORIZED)
        openedTasks = request.user.opened_tasks()
        if openedTasks:
            serializer = self.serializer_class(openedTasks.first())
            return response.Response(serializer.data, status=status.HTTP_200_OK)
        else:
            return response.Response(status=status.HTTP_200_OK)
