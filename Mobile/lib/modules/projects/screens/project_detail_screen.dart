import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ontts/modules/accounts/cubit/account_cubit.dart';
import 'package:ontts/modules/projects/cubit/project_states.dart';
import 'package:ontts/modules/projects/cubit/projects_cubit.dart';
import 'package:ontts/shared/component/constants.dart';

class ProjectDetailScreen extends StatelessWidget {
  //const ProjectDetailScreen({Key? key, this.id}) : super(key: key);
  final int id;

  const ProjectDetailScreen(this.id);

  @override
  Widget build(BuildContext context) {
    var projectCubit = ProjectCubit.get(context);
    var accountCubit = AccountCubit.get(context);

    projectCubit.getProjectTasks(accountCubit.token, id);
    projectCubit.getProjectMembers(accountCubit.token, id);

    return BlocConsumer<ProjectCubit, ProjectStates>(
        builder: (context, state) {
          var tasks = projectCubit.projectTasks;
          return Column(children: [
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) =>
                      taskBuilder(context, tasks[index]),
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 15,
                      ),
                  itemCount: tasks.length),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: () {},
                  child: const Icon(Icons.add),
                ),
              ],
            )
          ]);
        },
        listener: (context, state) {});
  }
}

Widget taskBuilder(context, task) {
  return MaterialButton(
    onPressed: () {},
    child: Dismissible(
      key: Key(task.id.toString()),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          print(direction);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(task.name + ' dismissed')));
        } else if (direction == DismissDirection.endToStart) {
          ProjectCubit.get(context)
              .startTime(AccountCubit.get(context).token, task);
        }
      },
      child: Container(
        decoration: card,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.name,
                      style: TextStyle(fontSize: headingFontSize),
                    ),
                    task.assignedTo != null
                        ? Chip(
                            label: Text(task.assignedTo.firstName +
                                ' ' +
                                task.assignedTo.lastName))
                        : Container(),
                    Text(task.description),
                  ],
                ),
              ),
              !ProjectCubit.get(context).checkIfTaskOpened(task)
                  ? IconButton(
                      onPressed: () {
                        ProjectCubit.get(context)
                            .startTime(AccountCubit.get(context).token, task);
                      },
                      icon: const Icon(Icons.play_arrow))
                  : IconButton(onPressed: () {}, icon: Icon(Icons.stop)),
            ],
          ),
        ),
      ),
    ),
  );
}
