import Foundation

final class QuestionFactory {
    
    // MARK: - private Enum
    private enum QuestionFactoryError: Error {
        case errorLoadImage
    }
    
    // MARK: - private properties
    private weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading
    
    private var mostPopularMovie: [MostPopularMovie] = []
    
    // MARK: - Initializer
    init(delegate: QuestionFactoryDelegate? = nil, moviesLoader: MoviesLoading) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }
}

// MARK: - QuestionFactoryProtocol
extension QuestionFactory: QuestionFactoryProtocol {
    func loadData() {
        DispatchQueue.global().async { [weak self] in
            self?.moviesLoader.loadMovies { [weak self] response in
                switch response {
                case .success(let mostPopularMovies):
                    self?.mostPopularMovie = mostPopularMovies.items
                    self?.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self?.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.mostPopularMovie.count).randomElement() ?? 0
            
            guard let movie = self.mostPopularMovie[safe: index] else { return }
            var imageData = Data()
            
            let data = try? Data(contentsOf: movie.resizedImageURL)
            
            guard let data = data else {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didFailToLoadImage(with: QuestionFactoryError.errorLoadImage)
                }
                return
            }
            
            imageData = data
            
            let rating = Float(movie.rating) ?? 0
            let correctAnswer = rating > 7
            
            let text = "Рейтинг этого вопроса больше 7?"
            
            let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
