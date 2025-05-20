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
    let name:String
    let address:String
}

func statusMessage(for status: String) -> String {
    switch status {
    case "pending": return "Order Received"
    case "accepted": return "Preparing Order"
    case "sold": return "Picked Up"
    case "denied": return "Cancelled"
    default: return "Order Received"
    }
}

func iconName(for status: String) -> String {
    switch status {
    case "pending": return "paperplane.circle.fill"          // 주문 접수 (대기 중 느낌)
    case "accepted": return "shippingbox.fill"               // 상품 준비됨
    case "sold": return "checkmark.circle.fill"              // 픽업 완료
    case "denied": return "exclamationmark.circle.fill"
    default: return "questionmark.circle"
    }
}

let stepStatuses = ["pending", "accepted", "sold"]


struct SampleWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SampleWidgetAttributes.self) { context in
            ZStack{
                VStack{
                    HStack(alignment:.center, spacing: 0){
                        HStack {
                            Image("LogoIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .background(Color(red: 1.0, green: 0.357, blue: 0.596))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            VStack(alignment:.leading){
                                Text(context.attributes.name).foregroundColor(Color.white.opacity(0.9)).fontWeight(.semibold).font(.system(size: 16))
                                Text(context.attributes.address).foregroundColor(Color.white.opacity(0.7)).font(.system(size: 12)).italic().lineLimit(2)
                                    .truncationMode(.tail)
                            }.padding(.leading, 4)
                            Spacer()
                        }
                        if context.state.status == "denied" {
                            Text(statusMessage(for: context.state.status))
                                .foregroundColor(Color(red: 1.0, green: 0.357, blue: 0.596))
                                .font(.system(size: 18, weight: .bold))
                        }
                    }
                
                    if context.state.status != "denied" {
                    HStack(alignment:.center) {
                            VStack() {
                                Text(statusMessage(for: context.state.status))
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .bold))
                            }
                            Spacer()
                            HStack(spacing: 0) {
                                ForEach(stepStatuses, id: \.self) { step in
                                    HStack(spacing: 0) {
                                        ZStack {
                                            Circle()
                                                .fill(stepStatuses.firstIndex(of: context.state.status)! >= stepStatuses.firstIndex(of: step)! ?
                                                       Color(red: 1.0, green: 0.357, blue: 0.596) : Color.white.opacity(0.3))
                                                .frame(width: 40, height: 40)
                                            Image(systemName: iconName(for: step))
                                                .foregroundColor(stepStatuses.firstIndex(of: context.state.status)! >= stepStatuses.firstIndex(of: step)! ?
                                                                 .white : .white.opacity(0.6))
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
                                                         ? Color(red: 1.0, green: 0.357, blue: 0.596)
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
                }.padding(.vertical, 20)
                    .padding(.horizontal, 20)
            }.edgesIgnoringSafeArea(.all)
                .activityBackgroundTint(.black.opacity(0.7))
                .activitySystemActionForegroundColor(.gray)
                

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image("LogoIcon")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                            .background(Color(red: 1.0, green: 0.357, blue: 0.596))
                                            .clipShape(RoundedRectangle(cornerRadius: 8)).padding(.top, 4).padding(.leading, 4)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack (alignment:.center){
                        if(context.state.status == "denied") {
                            Text(statusMessage(for: context.state.status))
                                .foregroundColor(Color(red: 1.0, green: 0.357, blue: 0.596))
                                .font(.system(size: 18, weight: .bold))
                        } else {
                            Text("Store").font(.system(size: 12)).foregroundColor(.white.opacity(0.7))
                            Text(context.attributes.name).font(.system(size: 16,weight: .bold)).foregroundColor(.white.opacity(0.9))
                        }
                    }.frame(height: 40).padding(.top, 4).padding(.trailing, 4)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    if context.state.status != "denied" {
                    HStack(alignment:.center) {
                            VStack() {
                                Text(statusMessage(for: context.state.status))
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .bold))
                            }
                            Spacer()
                            HStack(spacing: 0) {
                                ForEach(stepStatuses, id: \.self) { step in
                                    HStack(spacing: 0) {
                                        ZStack {
                                            Circle()
                                                .fill(stepStatuses.firstIndex(of: context.state.status)! >= stepStatuses.firstIndex(of: step)! ?
                                                       Color(red: 1.0, green: 0.357, blue: 0.596) : Color.white.opacity(0.3))
                                                .frame(width: 40, height: 40)
                                            Image(systemName: iconName(for: step))
                                                .foregroundColor(stepStatuses.firstIndex(of: context.state.status)! >= stepStatuses.firstIndex(of: step)! ?
                                                                 .white : .white.opacity(0.6))
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
                                                         ? Color(red: 1.0, green: 0.357, blue: 0.596)
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
            } compactLeading: {
                Image("LogoIcon")
                    .resizable()
                    .scaledToFit()
                    .background(Color(red: 1.0, green: 0.357, blue: 0.596))
                    .clipShape(RoundedRectangle(cornerRadius: 4)).padding(.leading, 4)
            } compactTrailing: {
                Image(systemName: iconName(for: context.state.status))
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(context.state.status=="sold" ? .green :.white)
                    .clipShape(RoundedRectangle(cornerRadius: 4)).padding(.trailing, 4)
            } minimal: {
                Image(systemName: iconName(for: context.state.status))
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(context.state.status=="sold" ? .green :.white)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

//@available(iOS 17.2, *)
//#Preview("Notification", as: .content, using: SampleWidgetAttributes()) {
//    SampleWidgetLiveActivity()
//} contentStates: {
//    SampleWidgetAttributes.ContentState(status: "In Store Pickup")
//}
