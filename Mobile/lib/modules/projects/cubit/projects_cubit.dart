import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ontts/models/projects/project_model.dart';
import 'package:ontts/models/projects/tasks_model.dart';
import 'package:ontts/models/projects/time_model.dart';
import 'package:ontts/modules/projects/cubit/project_states.dart';
import 'package:ontts/shared/component/component.dart';
import 'package:ontts/shared/component/functions.dart';
import 'package:ontts/shared/network/remote/dio_helper.dart';

class ProjectCubit extends Cubit<ProjectStates> {
  ProjectCubit() : super(ProjectInitialState());

  static ProjectCubit get(context) => BlocProvider.of(context);
  ProjectTime? openedTask;
  List<Task?> projectTasks = [];
  List<dynamic> projects = [];

  startTime(token, task) {
    emit(TimeStartLoadingState());
    DioHelper.postData(
            url: 'projects/time/start/',
            data: {'project_id': task.project.id, 'task_id': task.id},
            token: token)
        .then((value) {
      openedTask = task;
      openedTask?.startedAt = DateTime.now();
      getDuration();
      emit(TimeStartDoneState());
    }).onError((error, stackTrace) {
      emit(TimeStartErrorState());
    });
  }

  stopTime(token, id) {
    emit(TimeStopLoadingState());
    DioHelper.postData(
            url: 'projects/time/stop/', data: {'time_id': id}, token: token)
        .then((value) {
      openedTask = null;
      emit(TimeStopDoneState());
    }).onError((error, stackTrace) {
      showToast(
          message: 'Error!' + error.toString(), backgroundColor: Colors.red);
      emit(TimeStopErrorState());
    });
  }

  getProjects(token) {
    emit(ProjectLoadingState());
    DioHelper.getData(url: 'projects/projects/', query: {}, token: token)
        .then((value) {
      var results = value.data['results'];
      projects = [];
      for (final project in results) {
        Project p =
            Project(project['id'], project['name'], project['description']);
        projects.add(p);
      }
      emit(ProjectDoneState());
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      emit(ProjectErrorState());
    });
  }

  getProjectMembers(token, id) {
    DioHelper.getData(
            url: 'projects/members/' + id.toString(),
            query: {'project_id': id},
            token: token)
        .then((value) {
      return null;
    }).onError((error, stackTrace) {
      return null;
    });
  }

  getProjectTasks(token, id) {
    emit(ProjectTasksLoadingState());
    DioHelper.getData(
            url: 'projects/tasks/', query: {'project_id': id}, token: token)
        .then((value) {
      var resp = value.data['results'];
      projectTasks = [];
      for (var task in resp) {
        projectTasks.add(taskCreator(task));
      }
      resp.map((task) => projectTasks.add(taskCreator(task)));
      emit(ProjectTasksDoneState());
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      emit(ProjectTasksErrorState());
    });
  }

  getTaskTimes(token, id) {}

  getOpenedTime(token) {
    emit(TimeLoadingState());
    DioHelper.postData(url: 'projects/opened/tasks/', data: {}, token: token)
        .then((value) {
      var resp = value.data;
      if (resp != null) {
        openedTask = timeCreator(resp);
        openedTask?.duration = durationCalculator(openedTask?.startedAt);
      }
      emit(TimeDoneState());
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(TimeErrorState());
    });
  }

  getDuration() {
    openedTask?.duration = durationCalculator(openedTask?.startedAt);
    emit(DurationUpdateState());
  }

  checkIfTaskOpened(task) {
    if (task.id == openedTask?.task.id) {
      return true;
    } else {
      return false;
    }
  }
}
