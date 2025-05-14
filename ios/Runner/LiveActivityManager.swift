// 📄 LiveActivityManager.swift

import Foundation
import ActivityKit

@available(iOS 16.1, *)
struct LiveActivityManager {
    static var currentActivity: Activity<OrderStatusWidgetAttributes>?

    static func start(completion: @escaping (String?) -> Void) {
        let attributes = OrderStatusWidgetAttributes()
        let state = OrderStatusWidgetAttributes.ContentState(status: "order_received")

        do {
            let activity = try Activity<OrderStatusWidgetAttributes>.request(
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
                    completion(token) // ✅ Flutter로 전달
                    break // 첫 토큰만 전달하고 중단
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

        let newState = OrderStatusWidgetAttributes.ContentState(status: status)
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
    
    static func endAfterDelay(status: String, seconds: Int = 3600) {
        guard let activity = currentActivity else {
            print("❌ End failed: no active Live Activity found")
            return
        }

        let finalState = OrderStatusWidgetAttributes.ContentState(status: status)
        let oneHourLater = Date().addingTimeInterval(TimeInterval(seconds)) // seconds = 3600

        Task {
            await activity.end(using: finalState, dismissalPolicy: .after(oneHourLater))
            print("🕒 Live Activity scheduled to end after \(seconds) seconds (status: \(status))")
            currentActivity = nil
        }
    }
}
