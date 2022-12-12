//
//  ViewController.swift
//  MovieQuiz
//
//  Created by Алексей Моторин on 09.12.2022.
//

import UIKit

class MovieQuizViewController: UIViewController {
    
    // MARK: - UIView
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
        button.tintColor = .ypBlack
        button.titleLabel?.font = UIFont.ypBold18
        button.layer.cornerRadius = 15
        button.setTitle("Нет", for: .normal)
        button.addTarget(self, action: #selector(noButtonClicked), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
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
        view.backgroundColor = .ypBackground
        addView()
        activateConstraint()
    }
    
    private func addView() {
        view.addSubview(stackView)
        
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
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.topDistanceToSuperView),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.leftDistanceToSuperView),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.rightDistanceToSuperView),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.bottomDistanceToSuperView),
            
            previewImage.widthAnchor.constraint(equalTo: previewImage.heightAnchor, multiplier: 2/3),
            
            questionLabel.topAnchor.constraint(equalTo: viewForQuestionLabel.topAnchor, constant: 13),
            questionLabel.leadingAnchor.constraint(equalTo: viewForQuestionLabel.leadingAnchor, constant: 43),
            trailingQuestionLabelConstraint,
            bottomQuestionLabelConstraint,
            
            yesButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func yesButtonClicked() {
        
    }
    
    @objc private func noButtonClicked() {
        
    }
}

