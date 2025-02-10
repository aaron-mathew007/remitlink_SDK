import Foundation

/// Handles user authentication and token management
class AuthenticationManager {
    static let shared = AuthenticationManager()
    private let keychainHelper = KeychainHelper.shared
    
    private init() {}

    // MARK: - Authenticate User
    func authenticate(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Define parameters
        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        // API Endpoint
        let endpoint = "/api/authenticate"
        
        // Make API request
        APIService.shared.makeRequest(endpoint: endpoint, method: "POST", headers: nil, body: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    // Decode the response
                    let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                    
                    // Save the token securely in the Keychain
                    self.keychainHelper.save(authResponse.token, key: "accessToken")

                    // Retrieve the access token from the Keychain
                    let token = self.keychainHelper.get(key: "accessToken")

                    // Delete the access token from the Keychain
                    self.keychainHelper.delete(key: "accessToken")
                    
                    // Return the token in the completion handler
                    completion(.success(authResponse.token))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Get Access Token
    func getAccessToken() -> String? {
        return keychainHelper.get(key: "accessToken")
    }

    // MARK: - Logout
    func logout() {
        keychainHelper.delete(key: "accessToken")
    }
}

// MARK: - AuthResponse Model
/// Model for the authentication response
struct AuthResponse: Decodable {
    let token: String
    let userId: String
    let expiresIn: Int
}
