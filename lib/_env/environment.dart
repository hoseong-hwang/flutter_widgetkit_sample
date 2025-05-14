import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgetkit_sample/_env/environment_type.dart';
import 'package:flutter_widgetkit_sample/_env/firebase_options.dart' as prod;
import 'package:flutter_widgetkit_sample/_env/firebase_options_dev.dart' as dev;
import 'package:flutter_widgetkit_sample/app.dart';

class Environment {
  static late Environment _instance;
  static late EnvironmentType _type;

  factory Environment.init(EnvironmentType type) {
    _type = type;
    _instance = const Environment._internal();
    return _instance;
  }

  const Environment._internal();

  Future<void> run() async {
    WidgetsFlutterBinding.ensureInitialized();
    final FirebaseOptions options = _type == EnvironmentType.prod
        ? prod.DefaultFirebaseOptions.currentPlatform
        : dev.DefaultFirebaseOptions.currentPlatform;
    await Firebase.initializeApp(options: options);
    runApp(const App());
  }

  static Environment get instance => _instance;
  static EnvironmentType get enviroment => _type;
}
