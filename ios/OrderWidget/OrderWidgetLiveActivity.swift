//
//  OrderWidgetLiveActivity.swift
//  OrderWidget
//
//  Created by ppbstudios on 5/21/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct OrderWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var status: String
    }
    var name: String
    var address: String
    var count : Int
}

struct OrderWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OrderWidgetAttributes.self) { context in
            VStack {
                Text("Hello \(context.state.status)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
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
//
//
//@available(iOS 17.2, *)
//#Preview("Notification", as: .content, using: OrderWidgetAttributes.preview) {
//   OrderWidgetLiveActivity()
//} contentStates: {
//    OrderWidgetAttributes.ContentState.smiley
//    OrderWidgetAttributes.ContentState.starEyes
//}
