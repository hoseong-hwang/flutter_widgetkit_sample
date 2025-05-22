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

private struct StepProgressView : View {
    let status: String
    let address: String
    
    var body: some View {
        HStack(alignment:.center) {
            VStack(alignment:.leading) {
                Text(statusMessage(for: status))
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold))
                Text(address).font(.system(size: 10)).fontWeight(.semibold).lineLimit(1).italic().foregroundColor(.white.opacity(0.7))
            }
            Spacer()
            HStack(spacing: 0) {
                ForEach(stepStatuses, id: \.self) { step in
                    HStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .fill(stepStatuses.firstIndex(of: status)! >= stepStatuses.firstIndex(of: step)! ?
                                    .yellow : Color.white.opacity(0.3))
                                .frame(width: 40, height: 40)
                            Image(systemName: statusIcon(for: step))
                                .foregroundColor(stepStatuses.firstIndex(of: status)! >= stepStatuses.firstIndex(of: step)! ?
                                                 Color(red: 0, green: 0.44, blue: 0.29) : .white.opacity(0.6))
                                .font(.system(size: 20, weight: .bold))
                        }
                        if step != stepStatuses.last {
                            if let currentIndex = stepStatuses.firstIndex(of: status),
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
    }
}

struct OrderWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OrderWidgetAttributes.self) { context in
            VStack(alignment:.leading) {
                HStack {
                    Image("LogoIcon").resizable().scaledToFit().frame(width: 40, height: 40).background(.white.opacity(0.2))                        .clipShape(RoundedRectangle(cornerRadius: 12))
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
                StepProgressView(status: context.state.status, address:context.attributes.address)
            }.padding(.horizontal, 16)
                .padding(.vertical, 20)
                .activityBackgroundTint(Color.black.opacity(0.6))
                .activitySystemActionForegroundColor(Color.black)
            
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image("LogoIcon").resizable().scaledToFit().frame(width: 40, height: 40).background(.white.opacity(0.2))                        .clipShape(.circle)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack {
                        Image(systemName: "takeoutbag.and.cup.and.straw.fill").foregroundColor(.yellow)
                        Text("\(context.attributes.count) items").font(.system(size: 10)).fontWeight(.semibold).padding(.horizontal, 4).foregroundColor(.yellow)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    StepProgressView(status: context.state.status, address:context.attributes.address).padding(.bottom,8)
                    // more content
                }
                DynamicIslandExpandedRegion(.center){
                    Text(context.attributes.name).font(.system(size: 10,weight: .semibold)).foregroundColor(.white.opacity(0.7)).italic()
                }
            } compactLeading: {
                Image("LogoIcon").resizable().scaledToFit().background(.white.opacity(0.2)).clipShape(.circle)
            } compactTrailing: {
                Image(systemName: statusIcon(for: context.state.status))
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.yellow)
                    .clipShape(RoundedRectangle(cornerRadius: 4)).padding(2)
            } minimal: {
                Image(systemName: statusIcon(for: context.state.status))
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.yellow)
                    .clipShape(RoundedRectangle(cornerRadius: 4)).padding(2)
            }
            .widgetURL(URL(string: "tyger://"))
            .keylineTint(Color.red)
        }
    }
}
