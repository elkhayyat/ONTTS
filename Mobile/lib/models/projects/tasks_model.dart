import 'package:ontts/models/accounts/user_model.dart';
import 'package:ontts/models/projects/project_model.dart';

class Task{
  int id;
  String name;
  String? description;
  Project project;
  User? assignedTo;
  dynamic deadline;
  bool isDone;


  Task(this.id, this.name, this.description, this.project, this.assignedTo, this.deadline, this.isDone);
}