import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock: MovieQuizViewControllerProtocol {
    func highlightImageBorder(isCorrectAnswer: Bool) {}
    func show(quiz step: MovieQuiz.QuizStepViewModel?) {}
    func showLoadingIndicator() {}
    func hideLoadingIndicator() {}
    func yesButtonClicked() {}
    func noButtonClicked() {}
    func enableButtons() {}
    func showResultAlert(viewController: UIAlertController?) {}
    func showErrorScreen() {}
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerProtocolMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question text", correctAnswer: true)
        
        guard let viewModel = sut.convert(model: question) else { return }
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }

}
