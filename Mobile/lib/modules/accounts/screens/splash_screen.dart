import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ontts/modules/accounts/cubit/account_cubit.dart';
import 'package:ontts/modules/accounts/cubit/account_states.dart';
import 'package:ontts/shared/component/component.dart';
import 'package:ontts/shared/component/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountCubit, AccountStates>(builder: (context, state) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          color: primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text(
                'ON-TTS',
                style: TextStyle(
                  fontSize: headingFontSize,
                  color: lightColor,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              loadingIcon(color: lightColor),
            ],
          ),
        ),
      );
    }, listener: (context, state) {

    });
  }
}
