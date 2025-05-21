import Foundation
import ActivityKit

@available(iOS 16.1, *)
struct OrderActivityManager {
    static var currentActivity: Activity<OrderWidgetAttributes>?
    
    static func start(name:String, address:String, count:Int, completion: @escaping (String?) -> Void) {
        let attributes = OrderWidgetAttributes(name: name, address: address, count: count)
        let state = OrderWidgetAttributes.ContentState(status: "received")

        do {
            let activity = try Activity<OrderWidgetAttributes>.request(
                attributes: attributes,
                contentState: state,
                pushType: .token
//                pushType: nil
            )
            currentActivity = activity
            Task {
                for await data in activity.pushTokenUpdates {
                    let token = data.map { String(format: "%02x", $0) }.joined()
                    print("📦 Push token: \(token)")
                    completion(token)
                    break
                }
            }
        } catch {
            print("❌ Failed to start Live Activity: \(error)")
            completion(nil)
        }
    }
}
