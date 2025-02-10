import Foundation

class TransactionManager {
    static let shared = TransactionManager()
    
    private init() {}

    func createTransaction(parameters: [String: Any], completion: @escaping (Result<Transaction, Error>) -> Void) {
        let endpoint = "/transactions"
        let headers = ["Authorization": "Bearer \(AuthenticationManager.shared.getAccessToken() ?? "")"]

        APIService.shared.makeRequest(endpoint: endpoint, method: "POST", headers: headers, body: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    let transaction = try JSONParser.decode(data, to: Transaction.self)
                    completion(.success(transaction))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchTransactions(completion: @escaping (Result<[Transaction], Error>) -> Void) {
        let endpoint = "/transactions"
        let headers = ["Authorization": "Bearer \(AuthenticationManager.shared.getAccessToken() ?? "")"]

        APIService.shared.makeRequest(endpoint: endpoint, method: "GET", headers: headers, body: nil) { result in
            switch result {
            case .success(let data):
                do {
                    let transactions = try JSONParser.decode(data, to: [Transaction].self)
                    completion(.success(transactions))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func enquireTransaction(transactionID: String, completion: @escaping (Result<Transaction, Error>) -> Void) {
        let endpoint = "/transactions/\(transactionID)"
        let headers = ["Authorization": "Bearer \(AuthenticationManager.shared.getAccessToken() ?? "")"]

        APIService.shared.makeRequest(endpoint: endpoint, method: "GET", headers: headers, body: nil) { result in
            switch result {
            case .success(let data):
                do {
                    let transaction = try JSONParser.decode(data, to: Transaction.self)
                    completion(.success(transaction))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTransactionReceipt(transactionID: String, completion: @escaping (Result<TransactionReceipt, Error>) -> Void) {
        let endpoint = "/transactions/\(transactionID)/receipt"
        let headers = ["Authorization": "Bearer \(AuthenticationManager.shared.getAccessToken() ?? "")"]

        APIService.shared.makeRequest(endpoint: endpoint, method: "GET", headers: headers, body: nil) { result in
            switch result {
            case .success(let data):
                do {
                    let receipt = try JSONParser.decode(data, to: TransactionReceipt.self)
                    completion(.success(receipt))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func cancelTransaction(transactionID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = "/transactions/\(transactionID)/cancel"
        let headers = ["Authorization": "Bearer \(AuthenticationManager.shared.getAccessToken() ?? "")"]

        APIService.shared.makeRequest(endpoint: endpoint, method: "POST", headers: headers, body: nil) { result in
            switch result {
            case .success:
                completion(.success("Transaction cancelled successfully"))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// Example Model for Transaction
struct Transaction: Decodable {
    let id: String
    let sender: String
    let receiver: String
    let amount: Double
    let currency: String
    let status: String
    let createdAt: String
}

struct TransactionReceipt: Decodable {
    let transactionID: String
    let receiptURL: String
}
