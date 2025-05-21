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

private func statusMessage(for status: String) -> String {
    switch status {
    case "received": return "Order Received"
    case "preparing": return "Preparing Order"
    case "ready_for_pickup": return "Ready for PickUp"
    default: return "Order Received"
    }
}

private func statusIcon(for status: String) -> String {
    switch status {
    case "received": return "creditcard.fill"
    case "preparing": return "hourglass"
    case "ready_for_pickup": return "flag.pattern.checkered"
    default: return "questionmark"
    }
}

private let stepStatuses = ["received", "preparing", "ready_for_pickup"]

struct OrderWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OrderWidgetAttributes.self) { context in
            VStack(alignment:.leading) {
                HStack {
                    Image(systemName: "apple.logo").resizable().scaledToFit().frame(width: 40, height: 40).background(.white.opacity(0.1)).cornerRadius(8)
                    VStack (alignment:.leading){
                        Text("In Store Pickup").font(.system(size: 12)).fontWeight(.semibold).foregroundColor(.white.opacity(0.7))
                        Text(context.attributes.name).lineLimit(1).font(.system(size: 16)).fontWeight(.bold).foregroundColor(.white)
                    }
                    Spacer()
                    VStack {
                        Image(systemName: "takeoutbag.and.cup.and.straw.fill").foregroundColor(.yellow)
                        Text("\(context.attributes.count) items").font(.system(size: 10)).fontWeight(.semibold).padding(.horizontal, 4).foregroundColor(.yellow)
                    }.frame(height: 45).background(.white.opacity(0.2)).cornerRadius(8)
                    
                }
                HStack(alignment:.center) {
                    VStack(alignment:.leading) {
                        Text(statusMessage(for: context.state.status))
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                        Text(context.attributes.address).font(.system(size: 10)).fontWeight(.semibold).lineLimit(1).italic().foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                    HStack(spacing: 0) {
                        ForEach(stepStatuses, id: \.self) { step in
                            HStack(spacing: 0) {
                                ZStack {
                                    Circle()
                                        .fill(stepStatuses.firstIndex(of: context.state.status)! >= stepStatuses.firstIndex(of: step)! ?
                                            .yellow : Color.white.opacity(0.3))
                                        .frame(width: 40, height: 40)
                                    Image(systemName: statusIcon(for: step))
                                        .foregroundColor(stepStatuses.firstIndex(of: context.state.status)! >= stepStatuses.firstIndex(of: step)! ?
                                            .black : .white.opacity(0.6))
                                        .font(.system(size: 20, weight: .bold))
                                }
                                if step != stepStatuses.last {
                                    if let currentIndex = stepStatuses.firstIndex(of: context.state.status),
                                       let stepIndex = stepStatuses.firstIndex(of: step),
                                       stepIndex < stepStatuses.count - 1 {
                                        
                                        let nextStep = stepStatuses[stepIndex + 1]
                                        let isLineActive = currentIndex >= stepStatuses.firstIndex(of: nextStep)!
                                        
                                        Rectangle()
                                            .fill(isLineActive
                                                  ? .yellow
                                                  : Color.white.opacity(0.3))
                                            .frame(width: 20, height: 6)
                                            .padding(.horizontal, 0)
                                            .offset(y: -1)
                                    }
                                }
                            }
                        }
                    }
                }.padding(.top,12)
                
                
            }.padding(.horizontal, 16)
                .padding(.vertical, 20)
                .activityBackgroundTint(Color.black.opacity(0.6))
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
