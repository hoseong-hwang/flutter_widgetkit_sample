//
//  ScoreWidgetLiveActivity.swift
//  ScoreWidget
//
//  Created by ppbstudios on 5/19/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ScoreWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ScoreWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ScoreWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
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
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ScoreWidgetAttributes {
    fileprivate static var preview: ScoreWidgetAttributes {
        ScoreWidgetAttributes(name: "World")
    }
}

extension ScoreWidgetAttributes.ContentState {
    fileprivate static var smiley: ScoreWidgetAttributes.ContentState {
        ScoreWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ScoreWidgetAttributes.ContentState {
         ScoreWidgetAttributes.ContentState(emoji: "🤩")
     }
}

//@available(iOS 17.2, *)


//#Preview("Notification", as: .content, using: ScoreWidgetAttributes.preview) {
//   ScoreWidgetLiveActivity()
//} contentStates: {
//    ScoreWidgetAttributes.ContentState.smiley
//    ScoreWidgetAttributes.ContentState.starEyes
//}
