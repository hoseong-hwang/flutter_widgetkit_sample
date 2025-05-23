import ActivityKit
import WidgetKit
import SwiftUI

struct ScoreWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var status: ScoreStateModel
    }
    var home: ScoreTeamModel
    var away: ScoreTeamModel
}

private func statusMessage(status: String) -> String {
    switch status {
    case "scheduled": return "Upcoming"
    case "inprogress": return "Live"
    case "closed": return "Final"
    case "cancelled": return "Cancelled"
    default: return "N/A"
    }
}

private func statusBoxColor(status:String)->Color {
    switch status {
    case "scheduled": return .blue.opacity(0.7)
    case "inprogress": return .green.opacity(0.7)
    case "closed": return .white.opacity(0.3)
    case "cancelled": return .red.opacity(0.7)
    default: return .black
    }
}
private func currentStatusWidget(status:String) -> some View {
    HStack {
        Text(statusMessage(status: status)).font(.system(size: 8,weight: .semibold)).foregroundColor(.white)
            .padding(.vertical,2).padding(.horizontal,8)
    }.background(statusBoxColor(status: status)).cornerRadius(8)
    
}

private struct TeamWidget: View{
    let team:ScoreTeamModel
    var body: some View {
        VStack {
            Image(team.logo).resizable().scaledToFit().cornerRadius(12).frame(width: 60, height: 60)
            Text(team.name).font(.system(size: 6, weight: .semibold)).foregroundColor(.white.opacity(0.6)).italic()
            Text(team.code).font(.system(size: 16, weight: .bold)).foregroundColor(.white).padding(.top, 4)
        }
    }
}

struct ScoreWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ScoreWidgetAttributes.self) { context in
            HStack {
                Spacer()
                TeamWidget(team: context.attributes.home)
                Spacer()
                VStack  {
                    HStack  {
                        Text(String(context.state.status.homeScore)).font(.system(size: 34,weight: .bold)).foregroundColor(.white)
                        Text(":").font(.system(size: 30,weight: .bold)).foregroundColor(.white.opacity(0.5)).padding(.horizontal, 12).padding(.bottom,4)
                        Text(String(context.state.status.awayScore)).font(.system(size: 34,weight: .bold)).foregroundColor(.white)
                    }.frame(alignment: .center).padding(.bottom,2)
                    Text(context.state.status.inning).font(.system(size: 12,weight: .bold)).foregroundColor(.white.opacity(0.7)).italic()
                    currentStatusWidget(status: context.state.status.status)
                }
                Spacer()
                TeamWidget(team: context.attributes.away)
                Spacer()
            }
            .activityBackgroundTint(Color(red: 20/255, green: 33/255, blue: 61/255))
            .activitySystemActionForegroundColor(.gray)
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading, content: {
                    Text(context.state.status.inning).font(.system(size: 10,weight: .semibold)).foregroundColor(.white).padding(.leading, 8)
                })
                DynamicIslandExpandedRegion(.trailing, content: {
                    currentStatusWidget(status: context.state.status.status).padding(.trailing, 8)
                })
                DynamicIslandExpandedRegion(.bottom,content: {
                    HStack {
                        HStack{
                            VStack {
                                Text("HOME").font(.system(size: 10, weight: .bold)).foregroundColor(.white.opacity(0.5))
                                Text(context.attributes.home.code).font(.system(size: 14, weight: .bold)).foregroundColor(.white.opacity(0.7))
                            }.padding(.trailing,8)
                            Image(context.attributes.home.logo).resizable().scaledToFit().frame(width: 35, height: 35).cornerRadius(8).padding(.trailing, 16)
                            Text(String(context.state.status.homeScore)).font(.system(size: 34,weight: .bold)).foregroundColor(.white)
                        }.padding(.leading,8)
                        Spacer()
                        Text("vs").font(.system(size: 20,weight: .bold)).foregroundColor(.white.opacity(0.3)).padding(.horizontal, 12).padding(.bottom,4)
                        Spacer()
                        HStack{
                            Text(String(context.state.status.awayScore)).font(.system(size: 34,weight: .bold)).foregroundColor(.white)
                            Image(context.attributes.away.logo).resizable().scaledToFit().frame(width: 35, height: 35).cornerRadius(8).padding(.leading, 16)
                            VStack {
                                Text("AWAY").font(.system(size: 10, weight: .bold)).foregroundColor(.white.opacity(0.5))
                                Text(context.attributes.away.code).font(.system(size: 14, weight: .bold)).foregroundColor(.white.opacity(0.7))
                            }.padding(.leading, 8)
                        }.padding(.trailing,8)
                    }.frame(width:.infinity, height: 50)
                })
            } compactLeading: {
                HStack {
                    Image(context.attributes.home.logo).resizable().scaledToFit().clipShape(.circle)
                    Text(String(context.state.status.homeScore)).font(.system(size:18, weight: .bold))
                }
            } compactTrailing: {
                HStack {
                    Text(String(context.state.status.awayScore)).font(.system(size:18, weight: .bold))
                    Image(context.attributes.away.logo).resizable().scaledToFit().clipShape(.circle)
                }
            } minimal: {
                if context.state.status.homeScore == context.state.status.awayScore {
                    Circle().foregroundColor(statusBoxColor(status: context.state.status.status))
                } else {
                    let winningLogo = context.state.status.homeScore > context.state.status.awayScore
                    ? context.attributes.home.logo
                    : context.attributes.away.logo
                    
                    Image(winningLogo)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                }
            }
            .widgetURL(URL(string: "tyger://"))
            .keylineTint(Color.red)
        }
    }
}
