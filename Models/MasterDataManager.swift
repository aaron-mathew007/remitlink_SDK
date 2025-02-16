
import Foundation

class MasterDataManager {
    static let shared = MasterDataManager()
    private init() {}
    private let basePath = "/raas/masters/v1"
    
    private func getHeaders() -> [String: String] {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(AuthenticationManager.shared.getAccessToken() ?? "")",
            "Sender": "your_sender_id",
            "Channel": "your_channel",
            "Company": "your_company",
            "Branch": "your_branch"
        ]
    }
    
    // Search Branches
    func searchBranches(query: String, completion: @escaping (Result<[Branch], Error>) -> Void) {
        let endpoint = "\(basePath)/branches/lookup?query=\(query)"
        APIService.shared.makeRequest(endpoint: endpoint, method: "GET", headers: getHeaders(), body: nil) { result in
            switch result {
            case .success(let data):
                do {
                    let branches = try JSONDecoder().decode([Branch].self, from: data)
                    completion(.success(branches))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Validate Account
    func validateAccount(parameters: [String: Any], completion: @escaping (Result<AccountValidationResponse, Error>) -> Void) {
        let endpoint = "\(basePath)/accounts/validation"
        APIService.shared.makeRequest(endpoint: endpoint, method: "POST", headers: getHeaders(), body: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(AccountValidationResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Fetch Master Data
    func getMasterData(completion: @escaping (Result<MasterData, Error>) -> Void) {
        let endpoint = "\(basePath)/codes"
        APIService.shared.makeRequest(endpoint: endpoint, method: "GET", headers: getHeaders(), body: nil) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(MasterData.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    // Get Exchange Rates
    func getRates(completion: @escaping (Result<[ExchangeRate], Error>) -> Void) {
        let endpoint = "\(basePath)/rates"
        APIService.shared.makeRequest(endpoint: endpoint, method: "GET", headers: getHeaders(), body: nil) { result in
            switch result {
            case .success(let data):
                do {
                    let rates = try JSONDecoder().decode([ExchangeRate].self, from: data)
                    completion(.success(rates))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Get Service Corridors
    func getServiceCorridors(completion: @escaping (Result<[ServiceCorridor], Error>) -> Void) {
        let endpoint = "\(basePath)/service-corridor"
        APIService.shared.makeRequest(endpoint: endpoint, method: "GET", headers: getHeaders(), body: nil) { result in
            switch result {
            case .success(let data):
                do {
                    let corridors = try JSONDecoder().decode([ServiceCorridor].self, from: data)
                    completion(.success(corridors))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


// MARK: - Models
struct Branch: Decodable {
    let id: String
    let name: String
}

struct AccountValidationResponse: Decodable {
    let isValid: Bool
    let message: String?
}

struct ExchangeRate: Decodable {
    let currency: String
    let rate: Double
}

struct ServiceCorridor: Decodable {
    let id: String
    let name: String
}


// MARK: - Models
struct MasterData: Decodable {
    let relationships: [MasterItem]
    let idTypes: [MasterItem]
    let sourcesOfIncomes: [MasterItem]
    let accountTypes: [MasterItem]
    let paymentModes: [MasterItem]
    let visaTypes: [MasterItem]
    let instruments: [MasterItem]
    let addressTypes: [MasterItem]
    let receivingModes: [MasterItem]
    let feeTypes: [MasterItem]
    let transactionStates: [TransactionState]
    let incomeTypes: [MasterItem]
    let incomeRangeTypes: [MasterItem]
    let cancelReasonCodes: [MasterItem]
    let transactionCountPerMonth: [MasterItem]
    let transactionVolumePerMonth: [MasterItem]
    let correspondents: [MasterItem]
    let businessTypes: [MasterItem]
    let documentTypes: [MasterItem]
    let proofContentTypes: [MasterItem]
}

struct MasterItem: Decodable {
    let code: String
    let name: String
}

struct TransactionState: Decodable {
    let state: String
    let subStates: [MasterItem]
}
