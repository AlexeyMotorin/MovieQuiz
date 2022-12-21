import UIKit

class MovieQuizViewController: UIViewController {
    
    // MARK: private properties
    private var movieQuizScreen: MovieQuizScreen!
    private var presenter: MovieQuizPresenter!
  
    
    // MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        viewSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Private Methods
    private func viewSettings() {
        movieQuizScreen = MovieQuizScreen()
        movieQuizScreen.viewController = self
        view.addSubview(movieQuizScreen)
        
        NSLayoutConstraint.activate([
            movieQuizScreen.topAnchor.constraint(equalTo: view.topAnchor),
            movieQuizScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieQuizScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieQuizScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - MovieQuizViewControllerProtocol
extension MovieQuizViewController: MovieQuizViewControllerProtocol {
    func highlightImageBorder(isCorrectAnswer: Bool) {
        movieQuizScreen.highlightImageBorder(isCorrectAnswer: isCorrectAnswer)
    }
    
    func show(quiz step: QuizStepViewModel?) {
        movieQuizScreen.clearImageViewBorderColorAndImage()
        movieQuizScreen.show(quiz: step)
    }
    
    func yesButtonClicked() {
        presenter.showAnswerResult(isCorrect: true)
    }
    
    func noButtonClicked() {
        presenter.showAnswerResult(isCorrect: false)
    }
    
    func enableButtons() {
        movieQuizScreen.enableButtons()
    }
    
    func showResultAlert(viewController: UIAlertController?) {
        guard let viewController else { return }
        present(viewController, animated: true)
    }
}


