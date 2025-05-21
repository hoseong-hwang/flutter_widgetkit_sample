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
        let order = FlutterMethodChannel(name: "live_activity_order", binaryMessenger: controller.binaryMessenger)
        
        order.setMethodCallHandler { call, result in
            switch call.method {
            case "start":
                guard let args =  call.arguments as? [String:Any],
                      let name = args["name"] as? String,
                      let address = args["address"] as? String,
                      let count = args["count"] as? Int else {
                    result(nil)
                    return
                }
                OrderActivityManager.start(name: name, address: address, count: count) { token in
                    result(token)
                }
            case "update":
                guard let args = call.arguments as? [String:Any],
                      let status = args["status"] as?  String else {
                    result(nil)
                    return
                }
                OrderActivityManager.update(status:status)
                result(nil)
            case "end_now":
                OrderActivityManager.endImmediately()
                result(nil)
            case "end_later":
                OrderActivityManager.endAfterDelay()
                result(nil)
            default:
                result(nil)
            }
        }
    }
    
}
