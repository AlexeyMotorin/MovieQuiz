
import UIKit

final class MovieQuizPresenter {
    
    // MARK: - Private Properties
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var quizFactory: QuiestionFactoryProtocol?
    private var question: QuizQuestion?
    
    private(set) var countQuestion = 10
    private(set) var correctAnswer = 0
    private var currentQuestion = 0
    
    // MARK: - Initializer
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        self.quizFactory = QuestionFactory(delegate: self)
        quizFactory?.requestNextQuestion()
    }
    
    // MARK: Public Methods
    func showAnswerResult(isCorrect: Bool) {
        viewController?.enableButtons()
        
        let result = checkCorrectAnswer(result: isCorrect)
        
        viewController?.highlightImageBorder(isCorrectAnswer: result)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.showNextQuestionOrResults()
            self?.viewController?.nextQuestion()
            self?.viewController?.enableButtons()
        }
    }
    
    func showQuestion() {
        guard let question else { return }
        guard let viewModel = convert(model: question) else { return }
        viewController?.show(quiz: viewModel)
    }
    
    
    func showNextQuestionOrResults() {
        if currentQuestion == countQuestion - 1 {
            viewController?.showResultAlert()
        } else {
            currentQuestion += 1
            quizFactory?.requestNextQuestion()
        }
    }
    
    func restartGame() {
        correctAnswer = 0
        currentQuestion = 0
        viewController?.nextQuestion()
    }
    
    // MARK: Private methods
    private func convert(model: QuizQuestion) -> QuizStepViewModel? {
        guard let image = UIImage(named: model.image) else { return nil }
        let question = model.text
        let questionNumber = "\(currentQuestion + 1)/\(countQuestion)"
        let viewModel = QuizStepViewModel(image: image, question: question, questionNumber: questionNumber)
        return viewModel
    }
    
    private func checkCorrectAnswer(result: Bool) -> Bool {
        if result == question?.correctAnswer {
            correctAnswer += 1
            return true
        } else {
            return false
        }
    }
}


extension MovieQuizPresenter: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        self.question = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
}
 
