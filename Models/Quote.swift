import Foundation

class QuoteManager {
    static let shared = QuoteManager()
    
    private init() {}

    func fetchQuotes(parameters: [String: Any], completion: @escaping (Result<[Quote], Error>) -> Void) {
        let endpoint = "/quotes"
        let headers = ["Authorization": "Bearer \(AuthenticationManager.shared.getAccessToken() ?? "")"]

        APIService.shared.makeRequest(endpoint: endpoint, method: "GET", headers: headers, body: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    let quotes = try JSONParser.decode(data, to: [Quote].self)
                    completion(.success(quotes))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// Example Model for Quote
struct Quote: Decodable {
    let id: String
    let amount: Double
    let currency: String
    let rate: Double
}
