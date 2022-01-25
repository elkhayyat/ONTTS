import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ontts/layouts/main_layout.dart';
import 'package:ontts/modules/accounts/cubit/account_cubit.dart';
import 'package:ontts/modules/accounts/cubit/account_states.dart';
import 'package:ontts/modules/projects/screens/project_list_screen.dart';
import 'package:ontts/shared/component/component.dart';
import 'package:ontts/shared/component/constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<AccountCubit, AccountStates>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: const Text('ON-TTS'),
            ),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                     Text(
                      'Login',
                      style: TextStyle(
                        fontSize: headingFontSize,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.mail), labelText: 'E-Mail'),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock), labelText: 'Password'),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(child: Container()),
                        state != LoginLoadingState()?
                        MaterialButton(
                            onPressed: () {
                              AccountCubit.get(context)
                                  .login(emailController.text, passwordController.text);
                            },
                            child: Container(
                              color: Colors.blue,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'Login',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            )):loadingIcon(),
                      ],
                    ),
                  ],
                ),
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          );
        },
        listener: (context, state) {
          if (state is LoginDoneState){
            showToast(message: 'Login Success', backgroundColor: Colors.green);
            navigateAndFinish(context, const MainLayout(ProjectListScreen(), Icons.home, 'Home'));
          }
          else if (state is LoginErrorState){
            showToast(message: 'Check email and password', backgroundColor: Colors.red);
          }

        });
  }
}
