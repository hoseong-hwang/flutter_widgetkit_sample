//
//  OrderStatusWidgetLiveActivity.swift
//  OrderStatusWidget
//
//  Created by ppbstudios on 5/14/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct OrderStatusWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var status: String
    }

}

@available(iOS 16.1, *)
struct OrderStatusWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OrderStatusWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
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

extension OrderStatusWidgetAttributes {
    fileprivate static var preview: OrderStatusWidgetAttributes {
        OrderStatusWidgetAttributes()
    }
}

extension OrderStatusWidgetAttributes.ContentState {
    fileprivate static var smiley: OrderStatusWidgetAttributes.ContentState {
        OrderStatusWidgetAttributes.ContentState(status: "😀")
     }
     
     fileprivate static var starEyes: OrderStatusWidgetAttributes.ContentState {
         OrderStatusWidgetAttributes.ContentState(status: "🤩")
     }
}

