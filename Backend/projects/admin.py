import imp
from django.contrib import admin
from projects import models

# Register your models here.
admin.site.register(models.Project)
admin.site.register(models.ProjectMember)
admin.site.register(models.ProjectTask)
admin.site.register(models.ProjectTime)