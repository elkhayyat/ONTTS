from django.db import models
from django.contrib.auth.models import AbstractUser
from django.forms import EmailField
from accounts.managers import CustomUserManager
from rest_framework.authtoken.models import Token

# Create your models here.


class User(AbstractUser):
    username = models.CharField(
        null=True, blank=True, unique=False, max_length=128)
    email = models.EmailField(unique=True, blank=False, null=False)

    EMAIL_FIELD = 'email'
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['']

    objects = CustomUserManager()

    def __str__(self):
        if self.first_name:
            return self.get_full_name()
        else:
            return self.email
        
    @property
    def token(self):
        token = Token.objects.get(user=self).token
        return token
    
    @property
    def projects(self):
        return self.project_set.all()

    def opened_tasks(self):
        tasks = self.projecttime_set.filter(end_at__isnull=True)
        return tasks

    def has_opened_tasks(self):
        user_opened_tasks = self.opened_tasks()
        if user_opened_tasks:
            return True
        else:
            return False
