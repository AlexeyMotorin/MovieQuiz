import Foundation

final class QuestionFactory {
    private weak var delegate: QuestionFactoryDelegate?
    
    init(delegate: QuestionFactoryDelegate? = nil) {
        self.delegate = delegate
    }
}

extension QuestionFactory: QuiestionFactoryProtocol {
    func requestNextQuestion() {
        
        let randomIndex = Int.random(in:  0..<MockQuestion.questions.count)
        let question = MockQuestion.questions[safe: randomIndex]
        
        delegate?.didReceiveNextQuestion(question: question)
    }
}
