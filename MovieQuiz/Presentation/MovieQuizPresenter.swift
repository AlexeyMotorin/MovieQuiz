
import UIKit

final class MovieQuizPresenter {
    
    // MARK: - Private Properties
    private weak var viewController: MovieQuizViewControllerProtocol?
    private(set) var questionFactory: QuestionFactoryProtocol?
    private var question: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticServise: StatisticServiceProtocol?
    
    private(set) var countQuestion = 10
    private(set) var correctAnswer = 0
    private var currentQuestionIndex = 0
    
    // MARK: - Initializer
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        
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
        if self.isLastGame() {
            saveStatistic()
            showResultAlert()
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func restartGame() {
        resetCorrectAnswerAndCurrentIndex()
        correctAnswer = 0
        currentQuestionIndex = 0
        questionFactory?.requestNextQuestion()
    }
    
    
    // MARK: Private methods
    private func convert(model: QuizQuestion) -> QuizStepViewModel? {
        guard let image = UIImage(data: model.image) else { return nil }
        let question = model.text
        let questionNumber = "\(currentQuestionIndex + 1)/\(countQuestion)"
        let viewModel = QuizStepViewModel(image: image, question: question, questionNumber: questionNumber)
        return viewModel
    }
    
    private func checkCorrectAnswer(result: Bool) -> Bool {
        viewController?.showLoadingIndicator()
        if result == question?.correctAnswer {
            correctAnswer += 1
            return true
        } else {
            return false
        }
    }
    
    private func saveStatistic() {
        statisticServise?.store(correct: correctAnswer, total: countQuestion)
    }
    

    
    // MARK: - check Game methods
    private func isLastGame() -> Bool {
        currentQuestionIndex == countQuestion - 1
    }
    
    private func resetCorrectAnswerAndCurrentIndex() {
        currentQuestionIndex = 0
        correctAnswer = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }

}

// MARK: - Alert
extension MovieQuizPresenter {
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
    
    private func showNetworkError(message: String) {
    
        let title = "Ошибка"
        let buttonText = "Попробовать еще раз"
        
        let alertModel = AlertModel(title: title, message: message, buttonText: buttonText) { [weak self] _ in
            guard let self = self else { return }

            self.questionFactory?.loadData()
        }
        
        alertPresenter?.requestShowAlertResult(alertModel: alertModel)
    }
    
    func showImageError(message: String) {
    
        let title = "Ошибка загрузки вопроса"
        let buttonText = "Повторить"
        
        let alertModel = AlertModel(title: title, message: message, buttonText: buttonText) { [weak self] _ in
            guard let self = self else { return }
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter?.requestShowAlertResult(alertModel: alertModel)
    }
}

//MARK: - QuestionFactoryDelegate
extension MovieQuizPresenter: QuestionFactoryDelegate {
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let error = error.localizedDescription
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewController?.showErrorScreen()
            self.showNetworkError(message: error)
        }
    }
    
    func didFailToLoadImage(with error: Error) {
        let error = error.localizedDescription
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewController?.showErrorScreen()
            self.showImageError(message: error)
        }
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        self.question = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.hideLoadingIndicator()
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

