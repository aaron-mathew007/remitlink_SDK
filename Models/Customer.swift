
import Foundation

class CustomerManager {
    static let shared = CustomerManager()
    
    private init() {}
    
    private let basePath = "/caas/api/v2/customer"
    
    // MARK: - Customer Validation
    
    func validateCustomer(parameters: [String: Any], completion: @escaping (Result<CustomerValidationResponse, Error>) -> Void) {
        let endpoint = "\(basePath)/validate"
        
        // Retrieve the access token
        guard let accessToken = AuthenticationManager.shared.getAccessToken() else {
            let error = NSError(domain: "AuthenticationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No access token found."])
            completion(.failure(error))
            return
        }
        
        // Set the headers
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        // Print the headers and request body for debugging
        print("Request headers: \(headers)")
        print("Request body: \(parameters)")
        
        // Make the API request
        APIService.shared.makeRequest(endpoint: endpoint, method: "POST", headers: headers, body: parameters) { result in
            switch result {
            case .success(let data):
                // Print the raw response for debugging
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw response: \(jsonString)")
                }
                
                do {
                    // Decode the response into the CustomerValidationResponse model
                    let response = try JSONDecoder().decode(CustomerValidationResponse.self, from: data)
                    
                    // Check if the status is "failure"
                    if response.status == "failure" {
                        // Handle the error response
                        let errorMessage = "Validation failed: \(String(describing: response.message))"
                        let error = NSError(domain: "ValidationError", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        completion(.failure(error))
                    } else {
                        // Handle the success response
                        completion(.success(response))
                    }
                } catch {
                    // Handle decoding errors
                    print("Decoding error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                // Handle API request errors
                print("API request failed: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Customer Onboarding
    
    func onboardCustomer(parameters: [String: Any], completion: @escaping (Result<CustomerOnboardingResponse, Error>) -> Void) {
        let endpoint = basePath
        
        // Retrieve the access token
        guard let accessToken = AuthenticationManager.shared.getAccessToken() else {
            let error = NSError(domain: "AuthenticationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No access token found."])
            completion(.failure(error))
            return
        }
        
        // Set the headers
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        // Print the headers and request body for debugging
        print("Request headers: \(headers)")
        print("Request body: \(parameters)")
        
        // Make the API request
        APIService.shared.makeRequest(endpoint: endpoint, method: "POST", headers: headers, body: parameters) { result in
            switch result {
            case .success(let data):
                // Print the raw response for debugging
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw response: \(jsonString)")
                }
                
                do {
                    // Decode the response into the CustomerOnboardingResponse model
                    let response = try JSONDecoder().decode(CustomerOnboardingResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    // Handle decoding errors
                    print("Decoding error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                // Handle API request errors
                print("API request failed: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Get Customer Details

    func getCustomerDetails(customerId: String, completion: @escaping (Result<CustomerOnboardingResponse, Error>) -> Void) {
        let endpoint = "\(basePath)/\(customerId)"

        // Retrieve the access token
        guard let accessToken = AuthenticationManager.shared.getAccessToken() else {
            let error = NSError(domain: "AuthenticationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No access token found."])
            completion(.failure(error))
            return
        }

        // Set the headers
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]

        // Make the API request
        APIService.shared.makeRequest(endpoint: endpoint, method: "GET", headers: headers, body: nil) { result in
            switch result {
            case .success(let data):
                do {
                    // Decode the response into the CustomerOnboardingResponse model
                    let response = try JSONDecoder().decode(CustomerOnboardingResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    // Handle decoding errors
                    print("Decoding error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                // Handle API request errors
                print("API request failed: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Customer Validation Response Model
    
    struct CustomerValidationResponse: Decodable {
        let status: String
        let statusCode: Int
        let errorCode: Int?
        let message: String? // Make this field optional
    }
    
    // MARK: - Customer Onboarding Response Model
    
    struct CustomerOnboardingResponse: Decodable {
        let id: String
        let name: String
        let email: String?
        let phone: String?
        let status: String
    }
    
    // MARK: - Customer Classification Model
    
    struct CustomerClassification: Encodable {
        let customerTypeId: Int
        let incomeType: Int
        let annualIncomeRangeId: Int
        let annualIncomeCurrencyCode: String
        let txnVolMonth: Int
        let txnCountMonth: Int
        let employerName: String
        let employerAddress: String
        let employerPhone: String
        let professionCategory: String
        let reasonForAcc: String
        let agentRefNo: String
        let socialLinks: [SocialLink]
        let firstLanguage: String
        let maritalStatus: Int
        let profilePhoto: ProfilePhoto
        
        enum CodingKeys: String, CodingKey {
            case customerTypeId = "customer_type_id"
            case incomeType = "income_type"
            case annualIncomeRangeId = "annual_income_range_id"
            case annualIncomeCurrencyCode = "annual_income_currency_code"
            case txnVolMonth = "txn_vol_month"
            case txnCountMonth = "txn_count_month"
            case employerName = "employer_name"
            case employerAddress = "employer_address"
            case employerPhone = "employer_phone"
            case professionCategory = "profession_category"
            case reasonForAcc = "reason_for_acc"
            case agentRefNo = "agent_ref_no"
            case socialLinks = "social_links"
            case firstLanguage = "first_language"
            case maritalStatus = "marital_status"
            case profilePhoto = "profile_photo"
        }
    }
    
    // MARK: - Profile Photo Model
    
    struct ProfilePhoto: Encodable {
        let base64Data: String
        let contentType: String
        
        enum CodingKeys: String, CodingKey {
            case base64Data = "base64_data"
            case contentType = "content_type"
        }
    }
    
    // MARK: - Social Link Model
    
    struct SocialLink: Encodable {
        let socialLinksId: Int
        let textField: String
        
        enum CodingKeys: String, CodingKey {
            case socialLinksId = "social_links_id"
            case textField = "text_field"
        }
    }
}
