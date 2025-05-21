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
    
    static func update(status: String) {
        guard let activity = currentActivity else {
            print("❌ Update failed: no active Live Activity found")
            return
        }

        let newState = OrderWidgetAttributes.ContentState(status: status)
        Task {
            await activity.update(using: newState)
            print("✅ Live Activity Updated: \(status)")
        }
    }
    
    static func endImmediately() {
        guard let activity = currentActivity else {
            print("❌ End failed: no active Live Activity found")
            return
        }

        Task {
            await activity.end(dismissalPolicy: .immediate)
            print("🛑 Live Activity ended immediately")
            currentActivity = nil
        }
    }
    
    static func endAfterDelay(seconds: Int = 60) {
        guard let activity = currentActivity else {
            print("❌ End failed: no active Live Activity found")
            return
        }

        let finalState = OrderWidgetAttributes.ContentState(status: "ready_for_pickup")
        let oneHourLater = Date().addingTimeInterval(TimeInterval(seconds))

        Task {
            await activity.end(using: finalState, dismissalPolicy: .after(oneHourLater))
            print("🕒 Live Activity scheduled to end after \(seconds) seconds (status: ready_for_pickup)")
            currentActivity = nil
        }
    }
}
