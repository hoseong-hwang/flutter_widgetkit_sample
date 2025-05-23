
import ActivityKit
import WidgetKit
import SwiftUI

struct StepWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var status: StepStateModel
    }
    var date: Date
}

struct StepWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: StepWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Step: \(context.state.status.step)")
                Text("Distance: \(context.state.status.distance)")
                Text("FloorsUp: \(context.state.status.floorsUp)")
                Text("FloorsDown: \(context.state.status.floorsDown)")
                Text("Pace: \(context.state.status.pace)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.status.step)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.status.step)")
            } minimal: {
                Text("\(context.state.status.step)")
            }
            .widgetURL(URL(string: "tyger://"))
            .keylineTint(Color.red)
        }
    }
}
