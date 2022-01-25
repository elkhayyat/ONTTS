import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ontts/layouts/main_layout.dart';
import 'package:ontts/modules/accounts/cubit/account_states.dart';
import 'package:ontts/modules/accounts/screens/login_screen.dart';
import 'package:ontts/modules/accounts/screens/splash_screen.dart';
import 'package:ontts/shared/bloc_observer.dart';
import 'package:ontts/shared/component/component.dart';
import 'package:ontts/shared/network/remote/dio_helper.dart';
import 'modules/accounts/cubit/account_cubit.dart';
import 'modules/projects/cubit/projects_cubit.dart';
import 'modules/projects/screens/project_list_screen.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  DioHelper.init();

  runApp(MultiBlocProvider(
    child: const MyApp(),
    providers: [
      BlocProvider(create: (context) => AccountCubit()),
      BlocProvider(create: (context) => ProjectCubit()),
    ],
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ON-TimeTrackingSystem',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AccountCubit.get(context);
    cubit.getLoggedInState();
    return BlocConsumer<AccountCubit, AccountStates>(
        builder: (context, state) {
          return const SplashScreen();
        }, listener: (context, state) {

      if (state is GetLoginStateDoneState) {
        if (AccountCubit.get(context).isLoggedIn) {
          navigateAndFinish(context, const MainLayout(ProjectListScreen(), Icons.home, 'Home'));
        } else {
          navigateAndFinish(context, const LoginScreen());
        }
      }
    });
  }
}
