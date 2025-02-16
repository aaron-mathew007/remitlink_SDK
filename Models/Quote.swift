import Foundation

class QuoteManager {
    static let shared = QuoteManager()
    
    private init() {}
    
    func createQuote(parameters: [String: Any], completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "/amr/ras/api/v1_0/ras/quote"
        let headers = [
            "Authorization": "Bearer \(AuthenticationManager.shared.getAccessToken() ?? "")",
            "Content-Type": "application/json"
        ]
        
        APIService.shared.makeRequest(endpoint: endpoint, method: "POST", headers: headers, body: parameters) { result in
            switch result {
            case .success(let data):
                // Log the raw response
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("API Response: \(jsonString)")
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let dataDict = json["data"] as? [String: Any], let quoteId = dataDict["quote_id"] as? String {
                            completion(.success(quoteId))
                        } else if let errorMessage = json["message"] as? String {
                            // Handle API error messages
                            completion(.failure(NSError(domain: "APIError", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                        } else {
                            completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
                        }
                    } else {
                        completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        
        struct QuoteResponse: Decodable {
            let data: QuoteData
        }
        
        struct QuoteData: Decodable {
            let quote_id: String
        }
    }
}
