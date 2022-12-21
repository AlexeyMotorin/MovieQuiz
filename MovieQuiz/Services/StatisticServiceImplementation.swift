import Foundation

final class StatisticServiceImplementation: StatisticServiceProtocol {
    
    // MARK: private Enum
    private enum Keys: String {
        case total, correct, bestGame, gamesCount
    }
    
    // MARK: Public properties
    var totalAccuracy: Double {
        let correct = userDefaults.double(forKey: Keys.correct.rawValue)
        let total = userDefaults.double(forKey: Keys.total.rawValue)
        return (correct / total) * 100
    }
    
    //  MARK: Private(set) properties
    private(set) var gameCount: Int {
        get { userDefaults.integer(forKey: Keys.gamesCount.rawValue) }
        set { userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue) }
    }
    
    private(set) var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(total: 0, correct: 0, bestGame: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить данные")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    //  MARK: - Private properties
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Public methods
    func store(correct count: Int, total amount: Int) {
        compareBestGame(currentGame: GameRecord(total: amount, correct: count, bestGame: Date()))
        incrementGameCount()
        saveCorrectAnswerAndTotal(total: amount, correct: count)
    }
    
    // MARK: - Private methods
    private func compareBestGame(currentGame: GameRecord) {
        if currentGame > bestGame {
            bestGame = currentGame
        }
    }
    
    private func incrementGameCount() {
        gameCount += 1
    }
    
    private func saveCorrectAnswerAndTotal(total: Int, correct: Int) {
        let newTotalValue = userDefaults.integer(forKey: Keys.total.rawValue) + total
        let newCorrectValue = userDefaults.integer(forKey: Keys.correct.rawValue) + correct
        userDefaults.set(newTotalValue, forKey: Keys.total.rawValue)
        userDefaults.set(newCorrectValue, forKey: Keys.correct.rawValue)
    }
}
