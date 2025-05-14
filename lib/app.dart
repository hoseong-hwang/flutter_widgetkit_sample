import 'package:flutter/material.dart';
import 'package:flutter_widgetkit_sample/_env/environment.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Shell(),
    );
  }
}

class Shell extends StatelessWidget {
  const Shell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(26, 26, 26, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(26, 26, 26, 1),
        centerTitle: false,
        title: RichText(
          text: TextSpan(
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(255, 255, 255, 1),
                fontSize: 20,
              ),
              children: [
                TextSpan(
                    text: Enviroment.enviroment.tag.isNotEmpty
                        ? "${Enviroment.enviroment.tag} "
                        : ""),
                const TextSpan(text: "WIDGETKIT"),
              ]),
        ),
      ),
    );
  }
}
