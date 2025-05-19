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

func statusMessage(for status: String) -> String {
    switch status {
    case "pending": return "Order Received"
    case "accepted": return "Preparing"
    case "sold": return "Picked Up"
//    case "denied": return "Cancelled"
    default: return "Order Received"
    }
}

func iconName(for status: String) -> String {
    switch status {
    case "pending": return "clock"              // 주문 접수 (대기 중 느낌)
    case "accepted": return "shippingbox.fill"   // 상품 준비됨
    case "sold": return "checkmark.circle.fill" // 픽업 완료
    default: return "questionmark.circle"
    }
}

let stepStatuses = ["pending", "accepted", "sold"]


struct SampleWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SampleWidgetAttributes.self) { context in
            ZStack{
//                Color(red: 1.0, green: 0.357, blue: 0.596)
                VStack{
                    HStack(alignment:.top,
                           spacing: 0){
                        Image(systemName: "cart.fill")
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color(red: 1.0, green: 0.357, blue: 0.596))
                            .clipShape(Circle())
                        VStack(alignment:.leading){
                            Text("Wynwood Pickup").foregroundColor(Color.white.opacity(0.8)).fontWeight(.semibold).font(.system(size: 16))
                            Text("adress dsfkdl 123").foregroundColor(Color.white.opacity(0.7)).font(.system(size: 12)).italic()
                        }.padding(.leading, 12)
                        Spacer()
                    }.padding(.bottom, 12)
                    HStack {
                            VStack(alignment: .center) {
                                Text(statusMessage(for: context.state.status))
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .padding(.leading, 8)
                            Spacer()
                            HStack(spacing: 0) {
                                ForEach(stepStatuses, id: \.self) { step in
                                    HStack(spacing: 0) {
                                        ZStack {
                                            Circle()
                                                .fill(stepStatuses.firstIndex(of: context.state.status)! >= stepStatuses.firstIndex(of: step)! ?
                                                      Color(red: 1.0, green: 0.357, blue: 0.596) : Color.white.opacity(0.3))
                                                .frame(width: 35, height: 35)

                                            Image(systemName: iconName(for: step))
                                                .foregroundColor(stepStatuses.firstIndex(of: context.state.status)! >= stepStatuses.firstIndex(of: step)! ?
                                                                 .white : .white.opacity(0.6))
                                                .font(.system(size: 16, weight: .bold))
                                        }

                                        if step != stepStatuses.last {
                                            Rectangle()
                                                .fill(Color.white.opacity(0.6))
                                                .frame(width: 16, height: 3)
                                                .padding(.horizontal, 4)
                                                .offset(y: -1)
                                        }
                                    }
                                }
                            }
                        }

                }.padding(.vertical, 16)
                    .padding(.horizontal, 12)
            }.edgesIgnoringSafeArea(.all)
                .activityBackgroundTint(Color(red: 1.0, green: 0.5647, blue: 0.6706))
                .activitySystemActionForegroundColor(.white)
                

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

//@available(iOS 17.2, *)
//#Preview("Notification", as: .content, using: SampleWidgetAttributes()) {
//    SampleWidgetLiveActivity()
//} contentStates: {
//    SampleWidgetAttributes.ContentState(status: "In Store Pickup")
//}
