import 'package:ontts/models/accounts/user_model.dart';
import 'package:ontts/models/projects/project_model.dart';
import 'package:ontts/models/projects/tasks_model.dart';

class ProjectTime {
  int id;
  Project? project;
  Task task;
  User user;
  DateTime startedAt;
  DateTime? endedAt;
  Duration? duration;

  ProjectTime(this.id, this.project, this.task, this.user, this.startedAt, this.endedAt, this.duration);
}