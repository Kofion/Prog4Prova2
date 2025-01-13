import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:sign_in_button/sign_in_button.dart';

import '../app/app_routs.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_divider.dart';
import '../widgets/custom_text_form_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Seja bem vindo!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextFormField(
                        label: 'Email',
                      ),
                      CustomTextFormField(
                        label: 'Senha',
                        isPasswordField: true,
                      ),
                      CustomButton(
                          label: 'Entrar',
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRouts.mainPage);
                          }),
                      SizedBox(
                        height: 40,
                      ),
                      CustomDivider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SignInButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRouts.mainPage);
                          },
                          Buttons.google,
                          text: 'Login com Google',
                          padding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            side: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Não possui uma conta?',
                            style: TextStyle(color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context)
                                        .pushNamed(AppRouts.signUpPage);
                                  },
                                text: ' Registre-se',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
