import 'package:flutter/material.dart';
import 'package:flutter_widgetkit_sample/_env/environment_type.dart';
import 'package:flutter_widgetkit_sample/app.dart';

class Enviroment {
  static late Enviroment _instance;
  static late EnviromentType _type;

  factory Enviroment.init(EnviromentType type) {
    _type = type;
    _instance = const Enviroment._internal();
    return _instance;
  }

  const Enviroment._internal();

  Future<void> run() async {
    WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    runApp(const App());
  }

  static Enviroment get instance => _instance;
  static EnviromentType get enviroment => _type;
}
