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

func iconName(for index: Int) -> String {
    switch index {
    case 0: return "doc.text"             // 주문 접수
    case 1: return "shippingbox"          // 상품 준비 중
    case 2: return "bell"                 // 픽업 가능
    case 3: return "checkmark"            // 픽업 완료
    default: return "questionmark"
    }
}

struct SampleWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SampleWidgetAttributes.self) { context in
            ZStack{
                Color.pink
                VStack{
                    HStack(spacing: 0){
                        Image(systemName: "cart.fill")
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.pink)
                            .clipShape(Circle())
                        VStack(alignment:.leading){
                            Text("Wynwood Pickup").foregroundColor(Color.white.opacity(0.9)).fontWeight(.semibold).font(.system(size: 16))
                            Text("adress dsfkdl 123").foregroundColor(Color.white.opacity(0.7)).font(.system(size: 12)).italic()
                        }.padding(.leading, 12)
                        Spacer()
                    }.padding(.bottom, 12)
                    HStack {
                        VStack (alignment:.center){
                            Text("Received")
                                .foregroundColor(.white.opacity(0.9))
                                .font(.system(size: 18, weight: .bold))
//                            Text("Received")
//                                .foregroundColor(.white.opacity(0.8))
//                                .font(.system(size: 10))
                        }.padding(.leading,8)
                        Spacer()
                        HStack(spacing: 0) {
                            ForEach(0..<4) { index in
                                HStack(spacing: 0) {
                                    ZStack {
                                        Circle()
                                            .fill(index < 2 ? Color.pink : Color.white.opacity(0.3))
                                            .frame(width: 30, height: 30)

                                        Image(systemName: iconName(for: index))
                                            .foregroundColor(index < 2 ? .white : .gray)
                                            .font(.system(size: 14, weight: .bold))
                                    }

                                    if index < 3 {
                                        Rectangle()
                                            .fill(Color.white.opacity(0.6))
                                            .frame(width: 16, height: 2)
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
                .activityBackgroundTint(Color.pink)
                .activitySystemActionForegroundColor(Color.gray)
                

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

@available(iOS 17.2, *)
#Preview("Notification", as: .content, using: SampleWidgetAttributes()) {
    SampleWidgetLiveActivity()
} contentStates: {
    SampleWidgetAttributes.ContentState(status: "In Store Pickup")
}
