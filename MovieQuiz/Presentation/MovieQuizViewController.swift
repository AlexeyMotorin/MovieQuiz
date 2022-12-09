//
//  ViewController.swift
//  MovieQuiz
//
//  Created by Алексей Моторин on 09.12.2022.
//

import UIKit

class MovieQuizViewController: UIViewController {

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
    }
}

