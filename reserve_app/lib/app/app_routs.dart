import 'package:flutter/material.dart';
import 'package:reserve_app/pages/login_page.dart';
import 'package:reserve_app/pages/main_page.dart';
import 'package:reserve_app/pages/reserves_page.dart';
import 'package:reserve_app/pages/sign_up_page.dart';

import '../pages/details_page.dart';

abstract class AppRouts {
  static const loginPage = 'login';
  static const signUpPage = 'signup';
  static const mainPage = 'main';
  static const reservesPage = 'reserves';
  static const detailsPage = '/details';

  // Rotas sem parâmetros
  static Map<String, WidgetBuilder> routes = {
    loginPage: (context) => LoginPage(),
    signUpPage: (context) => SignUp(),
    mainPage: (context) => MainPage(),
    reservesPage: (context) => ReservesPage(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == detailsPage) {
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => DetailsPage(
          name: args['name'],
          capacity: args['capacity'],
          status: args['status'],
        ),
      );
    }
    // Retorna null ou uma página de erro se a rota não for encontrada
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(child: Text("Página não encontrada")),
      ),
    );
  }
}
