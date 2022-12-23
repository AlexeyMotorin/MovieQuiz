import Foundation

final class QuestionFactory {
    
    private weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading
    
    private var mostPopularMovie: [MostPopularMovie] = []
    
    init(delegate: QuestionFactoryDelegate? = nil, moviesLoader: MoviesLoading) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }
}

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
        
        let randomIndex = Int.random(in:  0..<MockQuestion.questions.count)
        let question = MockQuestion.questions[safe: randomIndex]
        
        delegate?.didReceiveNextQuestion(question: question)
    }
}
