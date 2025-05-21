import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgetkit_sample/_env/environment.dart';
import 'package:flutter_widgetkit_sample/d_live_activity_helper.dart';

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
    String? token = await FirebaseMessaging.instance.getToken();
    print("pushToken : $token");
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
      body: Column(
        children: [
          _button(
              display: "Start LiveActivity",
              onTap: () => DLiveActivityHelper.startLiveActivity()),
          _button(
              display: "Update (Preparing)",
              onTap: () => DLiveActivityHelper.updateLiveActivity("accepted")),
          _button(
              display: "Update (Picked Up)",
              onTap: () => DLiveActivityHelper.updateLiveActivity("sold")),
          _button(
              display: "Update (Cancelled)",
              onTap: () => DLiveActivityHelper.updateLiveActivity("denied")),
          _button(
              display: "End Now",
              onTap: () => DLiveActivityHelper.endLiveActivity()),
          _button(
              display: "End in 1 Hour",
              onTap: () => DLiveActivityHelper.endLiveActivityWithDelay()),
        ],
      ),
    );
  }

  GestureDetector _button({
    required String display,
    required Function() onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color.fromRGBO(96, 96, 96, 1),
          ),
          alignment: Alignment.center,
          child: Text(
            display,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      );
}
