import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies,Error>) -> Void)
}

struct MoviesLoader {
    
    // MARK: - private EnumError
    private enum MoviesLoaderError: Error {
        case parseJSONError
        case mostPopularMoviesItemsError
    }
    
    // MARK: - private properties
    private let networkClien: NetworkRouting
    private var mostPopulatMoviesURL: URL {
        let stringURL = "https://imdb-api.com/en/API/Top250Movies/k_ykrgq4kf"
        guard let url = URL(string: stringURL) else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    // MARK: - Initializer
    init(networkClien: NetworkRouting = NetworkClient()) {
        self.networkClien = networkClien
    }
}

// MARK: - MoviesLoading
extension MoviesLoader: MoviesLoading {
    
    // MARK: - public methods
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClien.fetch(url: mostPopulatMoviesURL) { response in
            switch response {
            case .success(let data):
                guard let mostPopularMovies = parseJSON(from: data) else {
                    handler(.failure(MoviesLoaderError.parseJSONError))
                    return
                }
                
                guard !mostPopularMovies.items.isEmpty else {
                    handler(.failure(MoviesLoaderError.mostPopularMoviesItemsError))
                    return
                }
                
                handler(.success(mostPopularMovies))
                
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    // MARK: - private Methods
    private func parseJSON(from data: Data) -> MostPopularMovies? {
        let decoder = JSONDecoder()
        return try? decoder.decode(MostPopularMovies.self, from: data)
    }
}
