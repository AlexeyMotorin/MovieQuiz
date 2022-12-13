
import UIKit

final class MovieQuizPresenter {
    
    // MARK: - Private Properties
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var question: QuizQuestion?
    
    private(set) var currentQuestionIndex = 0
    private var correctAnswer = 0
    
    // MARK: - Initializer
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        question = MockQuestion.questions[currentQuestionIndex]
    }
    
    // MARK: Public Methods
    func showAnswerResult(isCorrect: Bool) {
        viewController?.enableButtons()
        let result = isCorrect == question?.correctAnswer
        
        viewController?.highlightImageBorder(isCorrectAnswer: result)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.showNextQuestionOrResults()
            self?.viewController?.nextQuestion()
            self?.viewController?.enableButtons()
        }
    }
    
    func showQuestion() {
        question = MockQuestion.questions[currentQuestionIndex]
        guard let question else { return }
        guard let viewModel = convert(model: question) else { return }
        viewController?.show(quiz: viewModel)
    }
    
    
    func showNextQuestionOrResults() {
        if currentQuestionIndex == MockQuestion.questions.count - 1 {
            viewController?.showResultAlert()
        } else {
            currentQuestionIndex += 1
            viewController?.nextQuestion()
        }
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        viewController?.nextQuestion()
    }
    
    // MARK: Private methods
    private func convert(model: QuizQuestion) -> QuizStepViewModel? {
        guard let image = UIImage(named: model.image) else { return nil }
        let question = model.text
        let questionNumber = "\(currentQuestionIndex + 1)/\(MockQuestion.questions.count)"
        let viewModel = QuizStepViewModel(image: image, question: question, questionNumber: questionNumber)
        return viewModel
    }
}
