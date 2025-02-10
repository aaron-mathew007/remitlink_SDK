import Foundation

class CustomerManager {
    static let shared = CustomerManager()
    
    private init() {}
    
    private let basePath = "/caas/api/v2/customer"
    
    /// Validate a customer by their ID or phone number
    func validateCustomer(parameters: [String: Any], completion: @escaping (Result<CustomerValidationResponse, Error>) -> Void) {
        let endpoint = "\(basePath)/validate"
        let headers = ["Authorization": "Bearer \(AuthenticationManager.shared.getAccessToken() ?? "")"]
        
        APIService.shared.makeRequest(endpoint: endpoint, method: "POST", headers: headers, body: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONParser.decode(data, to: CustomerValidationResponse.self)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Onboard a new customer
    func onboardCustomer(parameters: [String: Any], completion: @escaping (Result<Customer, Error>) -> Void) {
        let endpoint = "\(basePath)/onboard"
        let headers = ["Authorization": "Bearer \(AuthenticationManager.shared.getAccessToken() ?? "")"]
        
        APIService.shared.makeRequest(endpoint: endpoint, method: "POST", headers: headers, body: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONParser.decode(data, to: Customer.self)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Fetch customer details by ID
    func fetchCustomerDetails(customerID: String, completion: @escaping (Result<Customer, Error>) -> Void) {
        let endpoint = "\(basePath)/\(customerID)"
        let headers = ["Authorization": "Bearer \(AuthenticationManager.shared.getAccessToken() ?? "")"]
        
        APIService.shared.makeRequest(endpoint: endpoint, method: "GET", headers: headers, body: nil) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONParser.decode(data, to: Customer.self)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// Example models for responses
struct CustomerValidationResponse: Decodable {
    let isValid: Bool
    let message: String?
}

struct Customer: Decodable {
    let id: String
    let name: String
    let email: String?
    let phone: String?
    let status: String
}
