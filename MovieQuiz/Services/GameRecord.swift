import Foundation

struct GameRecord: Codable {
    var total: Int
    var correct: Int
    let bestGame: Date
}

extension GameRecord: Comparable {
    static func > (lrh: GameRecord, rhs: GameRecord) -> Bool {
        guard lrh.correct > rhs.correct else { return false }
        return true
    }
    
    static func < (lrh: GameRecord, rhs: GameRecord) -> Bool {
        guard lrh.correct < rhs.correct else { return false }
        return true
    }
}
