import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:reserve_app/firebase_options.dart';

import 'package:reserve_app/app/reserve_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ReserveApp());
}
