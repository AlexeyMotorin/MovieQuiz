
import UIKit

final class MovieQuizPresenter {
    
    // MARK: - Private Properties
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var question: QuizQuestion?
    
    private(set) var currentQuestionIndex = 0
    private var correctAnswer = 0
    
    // MARK: - Initizlizers
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
            self?.currentQuestionIndex += 1
            self?.viewController?.nextQuestion()
            self?.viewController?.enableButtons()
        }
    }
    
    func showQuiesion() {
        question = MockQuestion.questions[currentQuestionIndex]
        guard let question else { return }
        guard let viewModel = convert(model: question) else { return }
        viewController?.showshow(quiz: viewModel)
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
