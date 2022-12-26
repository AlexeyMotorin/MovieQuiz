import Foundation

struct MockQuestion {
    static let questions: [QuizQuestionMock] = [
        QuizQuestionMock(image: "Deadpool", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
        QuizQuestionMock(image: "Kill Bill", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
        QuizQuestionMock(image: "Old", text: "Рейтинг этого фильма больше 6?", correctAnswer: false),
        QuizQuestionMock(image: "Tesla", text: "Рейтинг этого фильма больше 6?", correctAnswer: false),
        QuizQuestionMock(image: "The Avengers", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
        QuizQuestionMock(image: "The Dark Knight", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
        QuizQuestionMock(image: "The Godfather", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
        QuizQuestionMock(image: "The Green Knight", text: "Рейтинг этого фильма больше 6?", correctAnswer: false),
        QuizQuestionMock(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше 6?", correctAnswer: false),
        QuizQuestionMock(image: "Vivarium", text: "Рейтинг этого фильма больше 6?", correctAnswer: false)
    ]
}
