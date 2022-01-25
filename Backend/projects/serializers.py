from projects import models
from rest_framework import serializers
from accounts import serializers as accountSerializers


class ProjectSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Project
        fields = '__all__'


class ProjectMemberSerializer(serializers.ModelSerializer):
    project = ProjectSerializer(many=False, read_only=True)
    user = accountSerializers.UserSerializer(many=False, read_only=True)

    class Meta:
        model = models.ProjectMember
        fields = '__all__'


class ProjectTaskSerializer(serializers.ModelSerializer):
    project = ProjectSerializer(many=False, read_only=True)
    assigned_to = accountSerializers.UserSerializer(many=False, read_only=True)

    class Meta:
        model = models.ProjectTask
        fields = '__all__'


class ProjectTimeSerializer(serializers.ModelSerializer):
    project = ProjectSerializer(many=False, read_only=True)
    task = ProjectTaskSerializer(many=False, read_only=True)
    user = accountSerializers.UserSerializer(many=False, read_only=True)

    class Meta:
        model = models.ProjectTime
        fields = '__all__'

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
