import 'package:ontts/models/accounts/user_model.dart';
import 'package:ontts/models/projects/project_model.dart';
import 'package:ontts/models/projects/tasks_model.dart';
import 'package:ontts/models/projects/time_model.dart';

projectCreator(resp) {
  return Project(resp['id'], resp['name'], resp['description']);
}

userCreator(resp) {
  if (resp != null) {
    return User(resp['id'], resp['first_name'], resp['last_name'],
        resp['email'], resp['token']);
  } else {
    return null;
  }
}

convertToNullableDateTime(s) {
  if (s != null) {
    return DateTime.parse(s);
  } else {
    return null;
  }
}

taskCreator(resp) {
  return Task(
      resp['id'],
      resp['name'],
      resp['description'],
      projectCreator(resp['project']),
      userCreator(resp['assigned_to']),
      convertToNullableDateTime(resp['deadline']),
      resp['is_done']);
}

timeCreator(resp) {
  if(resp != '') {
    return ProjectTime(
        resp['id'],
        projectCreator(resp['project']),
        taskCreator(resp['task']),
        userCreator(resp['user']),
        convertToNullableDateTime(resp['start_at']),
        convertToNullableDateTime(resp['end_at']),
        resp['duration']);
  }else{
    return null;
  }
}

durationCalculator(startTime, {endTime}) {
  endTime ??= DateTime.now();
  return endTime.difference(startTime);
}
