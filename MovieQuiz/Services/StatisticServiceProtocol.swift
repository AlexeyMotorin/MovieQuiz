import Foundation

protocol StatisticServiceProtocol: AnyObject {
    var totalAccuracy: Double { get }
    var gameCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int) 
}
