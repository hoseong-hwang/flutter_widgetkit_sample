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
    
    
    override func applicationWillTerminate(_ application: UIApplication) {
        StepActivityManager.end()
    }
    
    private func configureLiveActivityChannel(controller: FlutterViewController) {
        let order = FlutterMethodChannel(name: "live_activity_order", binaryMessenger: controller.binaryMessenger)
        let score = FlutterMethodChannel(name:"live_activity_score", binaryMessenger: controller.binaryMessenger)
        let step = FlutterMethodChannel(name:"live_activity_step", binaryMessenger: controller.binaryMessenger)
        
        step.setMethodCallHandler { call, result in
            switch call.method {
            case "start":
                StepActivityManager.start()
                result(nil)
            default:
                result(nil)
            }
            
        }
        
        score.setMethodCallHandler { call, result in
            switch call.method {
            case "start":
                guard let args = call.arguments as? [String: Any],
                      let homeDict = args["home"] as? [String: Any],
                      let awayDict = args["away"] as? [String: Any],
                      let statusDict = args["status"] as? [String: Any] else {
                    result(nil)
                    return
                }
                
                do {
                    let homeData = try JSONSerialization.data(withJSONObject: homeDict)
                    let awayData = try JSONSerialization.data(withJSONObject: awayDict)
                    let statusData = try JSONSerialization.data(withJSONObject: statusDict)
                    
                    let home = try JSONDecoder().decode(ScoreTeamModel.self, from: homeData)
                    let away = try JSONDecoder().decode(ScoreTeamModel.self, from: awayData)
                    let status = try JSONDecoder().decode(ScoreStateModel.self, from: statusData)
                    
                    ScoreActivityManager.start(home: home, away: away, status: status) { token in
                        result(token)
                    }
                } catch {
                    result(nil)
                }
            case "update":
                guard let args = call.arguments as? [String: Any],
                      let statusDict = args["status"] as? [String: Any] else {
                    result(nil)
                    return
                }
                do {
                    
                    let statusData = try JSONSerialization.data(withJSONObject: statusDict)
                    let status = try JSONDecoder().decode(ScoreStateModel.self, from: statusData)
                    ScoreActivityManager.update(status: status)
                    result(nil)
                } catch {
                    result(nil)
                }
            default:
                result(nil)
            }
        }
        
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
