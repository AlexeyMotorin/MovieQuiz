import UIKit

final class MovieQuizScreen: UIView {
    
    // MARK: - Public Properties
    weak var viewController: MovieQuizViewControllerProtocol?
 
    // MARK: - Private Properties
    private var enabledButtons = true
   
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.contentMode = .scaleToFill
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var questionTitleAndIndexLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.contentMode = .scaleToFill
        return stackView
    }()
    
    private lazy var questionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.ypMedium20
        label.textColor = .ypWhite
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "Вопрос"
        return label
    }()
    
    private lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.ypMedium20
        label.textColor = .ypWhite
        label.numberOfLines = 1
        label.textAlignment = .right
        label.text = "1/10"
        return label
    }()
    
    private lazy var previewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .ypWhite
        return imageView
    }()
    
    private lazy var viewForQuestionLabel: UIView = {
        let view = UIView()
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.ypBold23
        label.textColor = .ypWhite
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Рейтинг этого фильма меньше, чем 5?"
        return label
    }()
    
    private lazy var yesNoButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.contentMode = .scaleToFill
        return stackView
    }()
    
    private lazy var yesButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypWhite
        button.tintColor = .ypBlack
        button.setTitleColor(.ypBlack, for: .normal)
        button.titleLabel?.font = UIFont.ypBold18
        button.layer.cornerRadius = 15
        button.setTitle("Да", for: .normal)
        button.addTarget(self, action: #selector(yesButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var noButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .ypWhite
        button.setTitleColor(.ypBlack, for: .normal)
        button.titleLabel?.font = UIFont.ypBold18
        button.layer.cornerRadius = 15
        button.setTitle("Нет", for: .normal)
        button.addTarget(self, action: #selector(noButtonClicked), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .ypBackground
        self.translatesAutoresizingMaskIntoConstraints = false
        addView()
        activateConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func show(quiz step: QuizStepViewModel?) {
        previewImage.image = step?.image
        questionLabel.text = step?.question
        indexLabel.text = step?.questionNumber
    }
        
    func highlightImageBorder(isCorrectAnswer: Bool) {
        previewImage.layer.masksToBounds = true
        previewImage.layer.borderWidth = 8
        previewImage.layer.cornerRadius = 20
        previewImage.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen?.cgColor : UIColor.ypRed?.cgColor
    }
    
    func clearImageViewBorderColorAndImage() {
        previewImage.layer.borderColor = UIColor.clear.cgColor
    }
    
    func enableButtons() {
        if enabledButtons {
            yesButton.isEnabled = false
            noButton.isEnabled = false
        } else {
            yesButton.isEnabled = true
            noButton.isEnabled = true
        }
        enabledButtons = !enabledButtons
    }
    
    // MARK: - Private Methods
    private func addView() {
        self.addSubview(stackView)
        
        stackView.addArrangedSubview(questionTitleAndIndexLabelStackView)
        questionTitleAndIndexLabelStackView.addArrangedSubview(questionTitleLabel)
        questionTitleAndIndexLabelStackView.addArrangedSubview(indexLabel)
        
        stackView.addArrangedSubview(previewImage)
        
        stackView.addArrangedSubview(viewForQuestionLabel)
        viewForQuestionLabel.addSubview(questionLabel)
        
        stackView.addArrangedSubview(yesNoButtonsStackView)
        yesNoButtonsStackView.addArrangedSubview(noButton)
        yesNoButtonsStackView.addArrangedSubview(yesButton)
    }
    
    private func activateConstraint() {
        let trailingQuestionLabelConstraint = questionLabel.trailingAnchor.constraint(equalTo: viewForQuestionLabel.trailingAnchor, constant: -43)
        trailingQuestionLabelConstraint.priority = UILayoutPriority(999)
        
        let bottomQuestionLabelConstraint = questionLabel.bottomAnchor.constraint(equalTo: viewForQuestionLabel.bottomAnchor, constant: -13)
        bottomQuestionLabelConstraint.priority = UILayoutPriority(1)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Constants.topDistanceToSuperView),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leftDistanceToSuperView),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.rightDistanceToSuperView),
            stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: Constants.bottomDistanceToSuperView),
            
            previewImage.widthAnchor.constraint(equalTo: previewImage.heightAnchor, multiplier: 2/3),
            
            questionLabel.topAnchor.constraint(equalTo: viewForQuestionLabel.topAnchor, constant: 13),
            questionLabel.leadingAnchor.constraint(equalTo: viewForQuestionLabel.leadingAnchor, constant: 43),
            trailingQuestionLabelConstraint,
            bottomQuestionLabelConstraint,
            
            yesButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func yesButtonClicked() {
        viewController?.yesButtonClicked()
    }
    
    @objc private func noButtonClicked() {
        viewController?.noButtonClicked()
    }
}
