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
        startLiveActivity();
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func startLiveActivity() {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            let attributes = ScoreWidgetAttributes(name: "TYGER")
            let contentState = ScoreWidgetAttributes.ContentState(emoji: "🔥")
            
            do {
                let _ = try Activity<ScoreWidgetAttributes>.request(
                    attributes: attributes,
                    contentState: contentState,
                    pushType: nil // or `.token` if push-to-start
                )
                print("✅ Live Activity started.")
            } catch {
                print("❌ Failed to start Live Activity: \(error)")
            }
        } else {
            print("⚠️ Live Activities are not enabled.")
        }
    }
    
    private func configureLiveActivityChannel(controller: FlutterViewController) {
        let channel = FlutterMethodChannel(name: "live_activity_channel", binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler { call, result in
            switch call.method {
            case "startLiveActivity":
                if #available(iOS 16.1, *) {
                    guard let args =  call.arguments as? [String:Any],
                          let name = args["name"] as? String,
                          let address = args["address"] as? String else {
                        result(nil)
                        return
                    }
                    LiveActivityManager.start(name:name, address:address) { token in
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
