import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func highlightImageBorder(isCorrectAnswer: Bool)
    func nextQuestion()
    func show(quiz step: QuizStepViewModel)
    func yesButtonClicked()
    func noButtonClicked()
    func enableButtons()
    func showResultAlert()
}
