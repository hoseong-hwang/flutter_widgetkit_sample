import Foundation
import ActivityKit

@available(iOS 16.1, *)
struct ScoreActivityManager {
    static var currentActivity: Activity<ScoreWidgetAttributes>?
    
    static func start(home:ScoreTeamModel, away:ScoreTeamModel,status:ScoreStateModel, completion: @escaping (String?) -> Void) {
        let attributes = ScoreWidgetAttributes(home: home, away: away)
        let state = ScoreWidgetAttributes.ContentState(status:status)
        
        do {
            let activity = try Activity<ScoreWidgetAttributes>.request(
                attributes: attributes,
                contentState: state,
                pushType: .token
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
    
    static func update(status: ScoreStateModel) {
        guard let activity = currentActivity else {
            print("❌ Update failed: no active Live Activity found")
            return
        }

        let newState = ScoreWidgetAttributes.ContentState(status: status)
        Task {
            await activity.update(using: newState)
            print("✅ Live Activity Updated: \(status)")
        }
    }
    
}
