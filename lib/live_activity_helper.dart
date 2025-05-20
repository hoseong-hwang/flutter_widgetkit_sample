import 'package:flutter/services.dart';

class LiveActivityHelper {
  static const MethodChannel channel = MethodChannel("live_activity_channel");

  static Future<void> startLiveActivity() async {
    final String? token = await channel.invokeMethod("startLiveActivity", {
      "name": "Wynwood",
      "address": "194 NW 24th St",
    });
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

  static void setTokenListener(void Function(String token) onToken) {
    channel.setMethodCallHandler((call) async {
      if (call.method == "onPushToStartToken") {
        final String token = call.arguments as String;
        print("📡 Push-to-Start Token: $token");
        onToken(call.arguments as String);
      }
    });
  }
}
