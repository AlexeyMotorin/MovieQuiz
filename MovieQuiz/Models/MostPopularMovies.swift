import Foundation

// MARK: - MostPopularMovies
struct MostPopularMovies: Codable {
    let items: [MostPopularMovie]
    let errorMessage: String
}

// MARK: - Item
struct MostPopularMovie: Codable {
    let title, rating: String
    let imageURL: URL
    
    var resizedImageURL: URL {
        let urlString = imageURL.absoluteString
        let imageURLString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        
        guard let newURL = URL(string: imageURLString) else {
            return imageURL
        }
        
        return newURL
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
