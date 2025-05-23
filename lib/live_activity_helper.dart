import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum LiveActivityType { order, score, step }

class LiveActivityHelper {
  static const MethodChannel order = MethodChannel("live_activity_order");
  static const MethodChannel score = MethodChannel("live_activity_score");
  static const MethodChannel step = MethodChannel("live_activity_step");

  static Future<void> start(LiveActivityType type) async {
    switch (type) {
      case LiveActivityType.step:
        await step.invokeMethod("start");
        return;
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
      case LiveActivityType.score:
        final String? token = await score.invokeMethod("start", {
          "home": {
            "code": "LAD",
            "name": "LA Dodgers (NL)",
            "logo": "LogoDodgers",
          },
          "away": {
            "code": "LAA",
            "name": "LA Angeles (AL)",
            "logo": "LogoAngeles",
          },
          "status": {
            "homeScore": 0,
            "awayScore": 0,
            "inning": "Top 1th",
            "status": "scheduled",
          },
        });
        if (kDebugMode) {
          print("LiveActivity Token : $token");
        }
        return;
      default:
        return;
    }
  }

  static Future<void> scoreUpdate() async {
    await score.invokeMethod("update", {
      "status": {
        "homeScore": 6,
        "awayScore": 0,
        "inning": "Bottom 1th",
        // "status": "scheduled",
        "status": "inprogress",
        // "status": "closed",
        // "status": "cancelled",
      }
    });
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
