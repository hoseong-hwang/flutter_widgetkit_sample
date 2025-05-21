import 'package:flutter/services.dart';

enum LiveActivityType { order }

class LiveActivityHelper {
  static const MethodChannel order = MethodChannel("live_activity_order");

  Future<void> start(LiveActivityType type) async {
    switch (type) {
      case LiveActivityType.order:
        final String? token = await order.invokeMethod("start", {
          "name": "Wynwood",
          "address": "194 NW 24th St",
          "count": 1,
        });
        print(token);
        return;
      default:
        return;
    }
  }
}
