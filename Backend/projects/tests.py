import imp
from operator import mod
from pydoc import describe
from django.test import TestCase
from projects import models

# Create your tests here.
class ProjectTestCase(TestCase):
    def setUp(self):
        models.Project.objects.create(name='Project 1', description='Project one description')
        models.Project.objects.create(name='Project 2', description='Project two description')
        
    def test_project(self):
        project1 = models.Project.objects.get(name='Project 1')
        project2 = models.Project.objects.get(name='Project 2')
        