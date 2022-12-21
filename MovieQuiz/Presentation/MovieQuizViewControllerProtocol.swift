import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func highlightImageBorder(isCorrectAnswer: Bool)
    func show(quiz step: QuizStepViewModel?)
    func yesButtonClicked()
    func noButtonClicked()
    func enableButtons()
    func showResultAlert(viewController: UIAlertController?)
}
