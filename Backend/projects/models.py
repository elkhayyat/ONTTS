from operator import mod
from statistics import mode
from tabnanny import verbose
from xmlrpc.client import Boolean
from django.db import models
from django.forms import BooleanField
from django.utils.translation import gettext_lazy as _
from django.contrib.auth.models import User
from django.conf import settings
from django.utils.timezone import now


# Create your models here.
class Project(models.Model):
    name = models.CharField(max_length=128, verbose_name=_('Project Name'))
    description = models.TextField(
        null=True, blank=True, verbose_name=_('Project Description'))

    def __str__(self):
        return self.name

    class Meta:
        ordering = ['-id']

class ProjectTask(models.Model):
    project = models.ForeignKey(Project, verbose_name=_(
        "Project"), on_delete=models.CASCADE)
    name = models.CharField(max_length=128, verbose_name=_('Task Name'))
    description = models.TextField(
        null=True, blank=True, verbose_name=_('Task Description')
    )
    assigned_to = models.ForeignKey(settings.AUTH_USER_MODEL, verbose_name=_(
        "User"), on_delete=models.SET_NULL, null=True, blank=True)
    is_done = models.BooleanField(default=False, verbose_name=_('Is Done?'))
    deadline = models.DateTimeField(
        null=True, blank=True, verbose_name=_('Deadline'))
    
    class Meta:
        ordering = ['-deadline']


class ProjectMember(models.Model):
    project = models.ForeignKey(
        Project, on_delete=models.CASCADE, verbose_name=_('Project'), related_name='members')
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, verbose_name=_('User'))

    def __str__(self):
        return self.user.__str__()
    
    class Meta:
        ordering = ['project']
        


class ProjectTime(models.Model):
    project = models.ForeignKey(
        Project, on_delete=models.CASCADE, verbose_name=_('Project'))
    task = models.ForeignKey(ProjectTask, on_delete=models.SET_NULL, null=True, blank=True, verbose_name=_('Task'))
    user = models.ForeignKey(settings.AUTH_USER_MODEL, verbose_name=_(
        "User"), on_delete=models.SET_NULL, null=True, blank=True)
    start_at = models.DateTimeField(
        auto_now_add=True, verbose_name=_('Start Time'))
    end_at = models.DateTimeField(
        null=True, blank=True, verbose_name=_('End Time'))
    duration = models.DurationField(null=True, verbose_name=_('Duration'), blank=True)

    def end_time(self):
        self.end_at = now()
        self.save()
        self.duration = self.end_at - self.start_at
        self.save()
        
    class Meta:
        ordering = ['-start_at']
