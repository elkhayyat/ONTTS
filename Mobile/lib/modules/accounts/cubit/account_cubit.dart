import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ontts/models/projects/time_model.dart';
import 'package:ontts/shared/component/component.dart';
import 'package:ontts/shared/component/functions.dart';
import 'package:ontts/shared/network/local/cache_helper.dart';
import 'package:ontts/shared/network/remote/dio_helper.dart';
import 'account_states.dart';

class AccountCubit extends Cubit<AccountStates> {
  AccountCubit() : super(LoginInitialState());

  static AccountCubit get(context) => BlocProvider.of(context);
  Widget title = Container();
  bool isLoggedIn = false;

  ProjectTime? openedTask;
  dynamic token;
  dynamic userData;

  getOpenedTime(token) {
    emit(TimeLoadingState());
    DioHelper.postData(url: 'projects/opened/tasks/', data: {}, token: token)
        .then((value) {
      var resp = value.data;
      if (resp != '') {
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
  login(email, password) {
    emit(LoginLoadingState());
    DioHelper.postData(
        url: 'accounts/login/',
        data: {'username': email, 'password': password}).then((value) {
      if (value.data['status']) {
        CacheHelper.saveData(key: 'token', value: value.data['data']['token']);
        CacheHelper.saveData(
            key: 'user_id', value: value.data['data']['user_id']);
        CacheHelper.saveData(key: 'isLoggedIn', value: true);
        token = value.data['data']['token'];
        emit(LoginDoneState());
      } else {
        emit(LoginUnAuthorizedState());
      }
    }).onError((error, stackTrace) {
      emit(LoginErrorState());
    });
  }

  getUserData(userID) async {
    CacheHelper.getData(key: 'token').then((value) {
      DioHelper.getData(
              url: 'accounts/users/' + userID + '/',
              query: {},
              token: value.toString())
          .then((value) {
        userData = value;
        emit(GetUserDataDoneState());
      });
    });
  }

  getLoggedInState() {
    emit(GetLoginStateLoadingState());
    CacheHelper.getData(key: 'isLoggedIn').then((value) {
      if (value != null) {
        isLoggedIn = value;
        CacheHelper.getData(key: 'token').then((value) {
          token = value;
          emit(GetLoginStateDoneState());
        });
      }
    });
  }

  logout() {
    emit(LogoutLoadingState());
    isLoggedIn = false;
    token = '';
    CacheHelper.saveData(key: 'isLoggedIn', value: false).then((value) {
      CacheHelper.saveData(key: 'token', value: '').then((value) {
        emit(LogoutDoneState());
      });
    });
  }

  stopTime(token, id) {
    emit(TimeStopLoadingState());
    DioHelper.postData(
        url: 'projects/time/stop/', data: {'time_id': id}, token: token).then((value) {
       openedTask = null;
      emit(TimeStopDoneState());
    }).onError((error, stackTrace) {
      showToast(message: 'Error!' + error.toString(), backgroundColor: Colors.red);
      emit(TimeStopErrorState());
    });
  }
}
