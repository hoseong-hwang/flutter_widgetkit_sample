import Flutter
import UIKit
import ActivityKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
      if let controller = window?.rootViewController as? FlutterViewController {
          configureLiveActivityChannel(controller: controller)
      }
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    private func configureLiveActivityChannel(controller: FlutterViewController) {
        let channel = FlutterMethodChannel(name: "live_activity_channel", binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler { call, result in
            switch call.method {
            case "startLiveActivity":
                if #available(iOS 16.1, *) {
                    LiveActivityManager.start { token in
                        result(token)
                    }
                } else {
                    print("⚠️ iOS 16.1+ required")
                }
                
            case "updateLiveActivity":
              if #available(iOS 16.1, *),
                 let args = call.arguments as? [String: Any],
                 let status = args["status"] as? String {
                print("✅ update called with: \(status)")
                LiveActivityManager.update(status: status)
              } else {
                print("⚠️ Failed to update: invalid arguments")
              }
              result(nil)
                
            case "endLiveActivity":
              if #available(iOS 16.1, *) {
                LiveActivityManager.endImmediately()
              } else {
                print("⚠️ iOS version too low to end Live Activity")
              }
              result(nil)
                
            case "endLiveActivityWithDelay":
              if #available(iOS 16.1, *),
                 let args = call.arguments as? [String: Any],
                 let status = args["status"] as? String {
                LiveActivityManager.endAfterDelay(status: status)
              } else {
                print("⚠️ Failed to end with delay: invalid arguments")
              }
              result(nil)
                
            default:
                print("⚠️ Unknown method: \(call.method)")
            }
        }
        
        if #available(iOS 17.2, *) {
          LiveActivityManager.observePushToStartToken { token in
            DispatchQueue.main.async {
              channel.invokeMethod("onPushToStartToken", arguments: token)
              }
            }
        }
    }
}
