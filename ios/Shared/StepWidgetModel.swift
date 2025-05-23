import Foundation

public struct StepStateModel:Codable, Hashable {
    let step: Int
    let distance: Double
    let floorsUp: Int
    let floorsDown: Int
    let pace : Double
}

