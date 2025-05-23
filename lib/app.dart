import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widgetkit_sample/_env/environment.dart';
import 'package:flutter_widgetkit_sample/d_live_activity_helper.dart';
import 'package:flutter_widgetkit_sample/live_activity_helper.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Shell(),
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  @override
  void initState() {
    super.initState();
    permission();
    getToken();
    DLiveActivityHelper.setTokenListener((_) {});
  }

  void permission() async {
    FirebaseMessaging.instance.requestPermission(
      badge: true,
      alert: true,
      sound: true,
    );
  }

  void getToken() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? token = await FirebaseMessaging.instance.getToken();
      if (kDebugMode) {
        print("Push Token : $token");
      }
    });
  }

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
                    text: Environment.enviroment.tag.isNotEmpty
                        ? "${Environment.enviroment.tag} "
                        : ""),
                const TextSpan(text: "WIDGETKIT"),
              ]),
        ),
      ),
      body: ListView(
        children: [
          _section("Order Activity"),
          _button(
              display: "Start LiveActivity",
              onTap: () => LiveActivityHelper.start(LiveActivityType.order)),
          _button(
              display: "Update (Preparing)",
              onTap: () => LiveActivityHelper.orderUpdate("preparing")),
          _button(
              display: "End Now",
              onTap: () => LiveActivityHelper.orderEndNow()),
          _button(
              display: "End in 1 Hour",
              onTap: () => LiveActivityHelper.orderEndLater()),
          _section("Score Activity"),
          _button(
              display: "Start LiveActivity",
              onTap: () => LiveActivityHelper.start(LiveActivityType.score)),
          _button(
              display: "Update", onTap: () => LiveActivityHelper.scoreUpdate()),
          _section("Step Activity"),
          _button(
              display: "Start LiveActivity",
              onTap: () => LiveActivityHelper.start(LiveActivityType.step)),
        ],
      ),
    );
  }

  GestureDetector _button({
    required String display,
    required Function() onTap,
  }) =>
      GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          onTap();
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: const Color.fromRGBO(96, 96, 96, 1),
          ),
          alignment: Alignment.center,
          child: Text(
            display,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      );

  Container _section(String name) => Container(
        height: 40,
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerLeft,
        child: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
