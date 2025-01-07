import 'package:flutter/material.dart';
import 'package:reserve_app/pages/login_page.dart';
import 'package:reserve_app/pages/main_page.dart';
import 'package:reserve_app/pages/reserves_page.dart';
import 'package:reserve_app/pages/sign_up_page.dart';

abstract class AppRouts {
  static const loginPage = 'login';
  static const signUpPage = 'signup';
  static const mainPage = 'main';
  static const reservesPage = 'reserves';

  static Map<String, WidgetBuilder> routes = {
    loginPage: (context) => LoginPage(),
    signUpPage: (context) => SignUp(),
    mainPage: (context) => MainPage(),
    reservesPage: (context) => ReservesPage(),
  };
}
