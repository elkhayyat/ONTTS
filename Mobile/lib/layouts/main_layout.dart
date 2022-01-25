import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ontts/models/projects/time_model.dart';
import 'package:ontts/modules/accounts/cubit/account_cubit.dart';
import 'package:ontts/modules/accounts/cubit/account_states.dart';
import 'package:ontts/modules/accounts/screens/login_screen.dart';
import 'package:ontts/modules/projects/cubit/project_states.dart';
import 'package:ontts/modules/projects/cubit/projects_cubit.dart';
import 'package:ontts/shared/component/component.dart';
import 'package:ontts/shared/component/constants.dart';

class MainLayout extends StatelessWidget {
  final Widget widget;
  final String title;
  final IconData icon;

  const MainLayout(this.widget, this.icon, this.title);

  @override
  Widget build(BuildContext context) {
    var projectCubit = ProjectCubit.get(context);
    var accountCubit = AccountCubit.get(context);
    projectCubit.getOpenedTime(accountCubit.token);
    return BlocConsumer<ProjectCubit, ProjectStates>(
        builder: (context, state) {
          ProjectTime? openedTask = projectCubit.openedTask;
          String? duration = openedTask?.duration.toString().split('.')[0];
          return Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
              title: Row(children: [
                Icon(icon),
                const SizedBox(
                  width: 15,
                ),
                Text(title),
              ]),
              actions: [
                IconButton(
                    onPressed: () {
                      AccountCubit.get(context).logout();
                      navigateAndFinish(context, const LoginScreen());
                    },
                    icon: const Icon(Icons.power_settings_new_outlined)),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: widget,
                )),
                openedTask != null
                    ? Container(
                        color: primaryColor,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    openedTask.task.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: paragraphFontSize,
                                        color: lightColor),
                                  ),
                                  Text(
                                    duration ?? '',
                                    style: TextStyle(
                                        fontSize: largeFontSize,
                                        color: lightColor),
                                  ),
                                ],
                              )),
                              IconButton(
                                onPressed: () {
                                  if (openedTask != null) {
                                    projectCubit.stopTime(
                                        accountCubit.token, openedTask?.id);
                                  }
                                  openedTask = projectCubit.openedTask;
                                },
                                icon: const Icon(Icons.stop),
                                color: lightColor,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          );
        },
        listener: (context, state) {});
  }
}
