//
//  SampleWidgetLiveActivity.swift
//  SampleWidget
//
//  Created by TYGER on 5/15/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SampleWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var status: String
    }
}

struct SampleWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SampleWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.status)")
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
                    Text("Bottom \(context.state.status)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.status)")
            } minimal: {
                Text(context.state.status)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension SampleWidgetAttributes {
    fileprivate static var preview: SampleWidgetAttributes {
        SampleWidgetAttributes()
    }
}


