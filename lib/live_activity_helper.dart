import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum LiveActivityType { order }

class LiveActivityHelper {
  static const MethodChannel order = MethodChannel("live_activity_order");

  static Future<void> start(LiveActivityType type) async {
    switch (type) {
      case LiveActivityType.order:
        final String? token = await order.invokeMethod("start", {
          "name": "The Original Starbucks",
          "address": "1912 Pike Place, Seattle",
          "count": 3,
        });
        if (kDebugMode) {
          print("LiveActivity Token : $token");
        }
        return;
      default:
        return;
    }
  }

  static Future<void> orderUpdate(String status) async {
    await order.invokeMethod("update", {"status": status});
  }

  static Future<void> orderEndNow() async {
    await order.invokeMethod("end_now");
  }

  static Future<void> orderEndLater() async {
    await order.invokeMethod("end_later");
  }
}
