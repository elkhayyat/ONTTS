import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ontts/layouts/main_layout.dart';
import 'package:ontts/modules/accounts/cubit/account_cubit.dart';
import 'package:ontts/modules/projects/cubit/project_states.dart';
import 'package:ontts/modules/projects/cubit/projects_cubit.dart';
import 'package:ontts/modules/projects/screens/project_detail_screen.dart';
import 'package:ontts/shared/component/component.dart';
import 'package:ontts/shared/component/constants.dart';

class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = ProjectCubit.get(context);
    var accountCubit = AccountCubit.get(context);
    var token = accountCubit.token;
    cubit.getProjects(token);
    cubit.getOpenedTime(token);

    return BlocConsumer<ProjectCubit, ProjectStates>(
        builder: (context, state) {
          List? projects = cubit.projects;
          if (state is ProjectLoadingState) {
            return Center(child: loadingIcon());
          } else if (state is ProjectErrorState) {
            return const Center(child: Text('Error! Loading Data'));
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {},
                        child: Container(
                          width: double.infinity,
                          color: primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'My Projects',
                                  style: TextStyle(color: lightColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {},
                        child: Container(
                          width: double.infinity,
                          color: secondaryColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'My Tasks',
                                  style: TextStyle(color: lightColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) =>
                        projectBuilder(context, projects[index]),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 15),
                    itemCount: projects.length,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(onPressed: (){}, child: Icon(Icons.add),),
                  ],
                ),
              ],
            );
          }
        },
        listener: (context, state) {});
  }
}

Widget projectBuilder(context, project) {
  return MaterialButton(
    onPressed: () {
      navigateTo(
          context,
          MainLayout(ProjectDetailScreen(project.id),
              Icons.featured_play_list_rounded, project.name));
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
                    project.name,
                    style: TextStyle(fontSize: largeFontSize),
                  ),
                  Text(
                    project.description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  '15/20',
                  style:
                      TextStyle(fontSize: largeFontSize, color: lightColor),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
