import 'package:flutter/services.dart';

class LiveActivityHelper {
  static const MethodChannel channel = MethodChannel("live_activity_channel");

  static Future<void> startLiveActivity() async {
    final String? token = await channel.invokeMethod("startLiveActivity");
    print(token);
  }

  static Future<void> updateLiveActivity(String status) async {
    await channel.invokeMethod("updateLiveActivity", {
      "status": status,
    });
  }

  static Future<void> endLiveActivity() async {
    await channel.invokeMethod("endLiveActivity");
  }

  static Future<void> endLiveActivityWithDelay() async {
    await channel.invokeMethod("endLiveActivityWithDelay", {
      "status": "delivered",
    });
  }
}
