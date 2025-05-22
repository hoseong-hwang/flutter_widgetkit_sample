
import Foundation

public struct ScoreStateModel:Codable, Hashable {
    let homeScore: Int
    let awayScore: Int
    let inning: String
    let status: String
}

public struct ScoreTeamModel: Codable, Hashable {
    let code:String
    let name:String
    let logo:String
}
