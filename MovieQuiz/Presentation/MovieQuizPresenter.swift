
import UIKit

final class MovieQuizPresenter {
    
    // MARK: - Private Properties
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private var question: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticServise: StatisticServiceProtocol?
    
    private(set) var countQuestion = 10
    private(set) var correctAnswer = 0
    private var currentQuestion = 0
    
    // MARK: - Initializer
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(delegate: self)
        
        alertPresenter = AlertPresenter()
        alertPresenter?.delegate = self
        
        statisticServise = StatisticServiceImplementation()
        
        questionFactory?.requestNextQuestion()
    }
    
    // MARK: Public Methods
    func showAnswerResult(isCorrect: Bool) {
        viewController?.enableButtons()
        
        let result = checkCorrectAnswer(result: isCorrect)
        
        viewController?.highlightImageBorder(isCorrectAnswer: result)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.showNextQuestionOrResults()
            self?.viewController?.enableButtons()
        }
    }
    
    func showNextQuestionOrResults() {
        if currentQuestion == countQuestion - 1 {
            saveStatistic()
            showResultAlert()
        } else {
            currentQuestion += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    func restartGame() {
        correctAnswer = 0
        currentQuestion = 0
        questionFactory?.requestNextQuestion()
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
    
    private func showResultAlert() {
        guard let statisticServise else { return }
        let bestGame = statisticServise.bestGame
        
        let title = "Раунд окончен!"
        let message = """
        Ваш результат: \(correctAnswer)/\(countQuestion)
        Количество сыгранных квизов: \(statisticServise.gameCount)
        Рекорд: \(bestGame.correct)/\(bestGame.total) \(bestGame.bestGame.dateTimeString)
        Средняя точность: \(String(format: "%.2f", statisticServise.totalAccuracy))%
        """
        
        let buttonText = "Сыграть еще раз"
        
        let alertModel = AlertModel(title: title, message: message, buttonText: buttonText ) { [weak self] _ in
            self?.restartGame()
        }
        
        alertPresenter?.requestShowAlertResult(alertModel: alertModel)
    }
    
    private func saveStatistic() {
        statisticServise?.store(correct: correctAnswer, total: countQuestion)
    }
}

//MARK: - QuestionFactoryDelegate
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

//MARK: - AlertPresenterDelegate
extension MovieQuizPresenter: AlertPresenterDelegate {
    func showAlert(alertController: UIAlertController?) {
        viewController?.showResultAlert(viewController: alertController)
    }
}

