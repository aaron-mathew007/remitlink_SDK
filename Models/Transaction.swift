import Foundation

class TransactionManager {
    static let shared = TransactionManager()
    
    private init() {}

    // Create a new transaction
    func createTransaction(parameters: [String: Any], completion: @escaping (Result<String, Error>) -> Void) {
            let endpoint = "/amr/ras/api/v1_0/ras/createtransaction" // Ensure this matches the API endpoint
            let headers = [
                "Authorization": "Bearer \(AuthenticationManager.shared.getAccessToken() ?? "")",
                "Content-Type": "application/json"
            ]

            APIService.shared.makeRequest(endpoint: endpoint, method: "POST", headers: headers, body: parameters) { result in
                switch result {
                case .success(let data):
                    // Log the raw response for debugging
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("API Response: \(jsonString)")
                    }

                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let transactionId = json["transaction_ref_number"] as? String {
                                completion(.success(transactionId))
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
        }
    

    // Fetch all transactions
    func fetchTransactions(completion: @escaping (Result<[Transaction], Error>) -> Void) {
        let endpoint = "/amr/ras/api/v1_0/ras/transactions"
        let headers = [
            "Authorization": "Bearer \(AuthenticationManager.shared.getAccessToken() ?? "")",
            "Content-Type": "application/json"
        ]

        APIService.shared.makeRequest(endpoint: endpoint, method: "GET", headers: headers, body: nil) { result in
            switch result {
            case .success(let data):
                do {
                    let transactions = try JSONDecoder().decode([Transaction].self, from: data)
                    completion(.success(transactions))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Enquire about a specific transaction
    func enquireTransaction(transactionID: String, completion: @escaping (Result<Transaction, Error>) -> Void) {
        let endpoint = "/amr/ras/api/v1_0/ras/enquire-transaction"
        let headers = [
            "Authorization": "Bearer \(AuthenticationManager.shared.getAccessToken() ?? "")",
            "Content-Type": "application/json"
        ]

        let queryParams = [
            "transaction_ref_number": transactionID
        ]

        var urlComponents = URLComponents(string: SDKConfig.shared.baseURL + endpoint)!
        urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        APIService.shared.makeRequest(endpoint: endpoint, method: "GET", headers: headers, body: nil) { result in
            switch result {
            case .success(let data):
                do {
                    let transaction = try JSONDecoder().decode(Transaction.self, from: data)
                    completion(.success(transaction))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Get the receipt for a specific transaction
    func getTransactionReceipt(transactionID: String, completion: @escaping (Result<TransactionReceipt, Error>) -> Void) {
        let endpoint = "/amr/ras/api/v1_0/ras/transaction-receipt"
        let headers = [
            "Authorization": "Bearer \(AuthenticationManager.shared.getAccessToken() ?? "")",
            "Content-Type": "application/json"
        ]

        let queryParams = [
            "transaction_ref_number": transactionID
        ]

        var urlComponents = URLComponents(string: SDKConfig.shared.baseURL + endpoint)!
        urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        APIService.shared.makeRequest(endpoint: endpoint, method: "GET", headers: headers, body: nil) { result in
            switch result {
            case .success(let data):
                do {
                    let receipt = try JSONDecoder().decode(TransactionReceipt.self, from: data)
                    completion(.success(receipt))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Cancel a transaction
    func cancelTransaction(transactionID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "/amr/ras/api/v1_0/ras/canceltransaction"
        let headers = [
            "Authorization": "Bearer \(AuthenticationManager.shared.getAccessToken() ?? "")",
            "Content-Type": "application/json"
        ]

        let body: [String: Any] = [
            "transaction_ref_number": transactionID,
            "cancel_reason": "R6",
            "remarks": "Account of the payment is incorrect"
        ]

        APIService.shared.makeRequest(endpoint: endpoint, method: "POST", headers: headers, body: body) { result in
            switch result {
            case .success:
                completion(.success("Transaction cancelled successfully"))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

    // MARK: - Confirm Transaction

    func confirmTransaction(transactionID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "/amr/ras/api/v1_0/ras/confirmtransaction"
        let headers = [
            "Authorization": "Bearer \(AuthenticationManager.shared.getAccessToken() ?? "")",
            "Content-Type": "application/json"
        ]

        let body: [String: Any] = [
            "transaction_ref_number": transactionID
        ]

        APIService.shared.makeRequest(endpoint: endpoint, method: "POST", headers: headers, body: body) { result in
            switch result {
            case .success:
                completion(.success("Transaction confirmed successfully"))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Transaction Status Inquiry
    func getTransactionStatus(transactionID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "/amr/ras/api/v1_0/ras/transaction-status"
        let headers = [
            "Authorization": "Bearer \(AuthenticationManager.shared.getAccessToken() ?? "")",
            "Content-Type": "application/json"
        ]

        let queryParams = [
            "transaction_ref_number": transactionID
        ]

        var urlComponents = URLComponents(string: SDKConfig.shared.baseURL + endpoint)!
        urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        APIService.shared.makeRequest(endpoint: endpoint, method: "GET", headers: headers, body: nil) { result in
            switch result {
            case .success(let data):
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let status = json["status"] as? String {
                        completion(.success(status))
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
    }

    // Transaction model
    struct Transaction: Decodable {
        let id: String
        let sender: String
        let receiver: String
        let amount: Double
        let currency: String
        let status: String
        let createdAt: String
    }

    // Transaction receipt model
    struct TransactionReceipt: Decodable {
        let transactionID: String
        let receiptURL: String
    }
