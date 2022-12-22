import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

struct NetworkClient: NetworkRouting {
   
    // MARK: - private EnumError
    private enum NetworkError: Error {
        case loadError
    }
    
    // MARK: = NetworkRouting
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(error))
            }
            
            if
                let response = response as? HTTPURLResponse,
                response.statusCode < 200, response.statusCode >= 300 {
                handler(.failure(NetworkError.loadError))
            }
            
            guard let data = data else {
                handler(.failure(NetworkError.loadError))
                return
            }
            
            handler(.success(data))
        }
        task.resume()
    }
}
