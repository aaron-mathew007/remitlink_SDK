import Foundation

class AuthenticationManager {
    static let shared = AuthenticationManager()
    private let keychainHelper = KeychainHelper.shared
    
    private init() {}

    // Authenticate the user and save the access token
        func authenticate(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
            let parameters: [String: Any] = [
                "username": username,
                "password": password,
                "grant_type": "password",
                "client_id": SDKConfig.shared.clientID,
                "client_secret": SDKConfig.shared.clientSecret
            ]
            
            var urlComponents = URLComponents()
            urlComponents.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
            
            guard let bodyData = urlComponents.query?.data(using: .utf8) else {
                completion(.failure(NSError(domain: "InvalidParameters", code: -1, userInfo: nil)))
                return
            }
            
            let endpoint = "/auth/realms/cdp/protocol/openid-connect/token"
            let headers = ["Content-Type": "application/x-www-form-urlencoded"]
            
            APIService.shared.makeRequest(endpoint: endpoint, method: "POST", headers: headers, body: nil, bodyData: bodyData) { result in
                switch result {
                case .success(let data):
                    do {
                        let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                        
                        // Save the access token to the Keychain
                        self.keychainHelper.save(authResponse.access_token, key: "access_token")
                        
                        // Print the access token for debugging
                        print("Access token saved: \(authResponse.access_token)")
                        
                        completion(.success(authResponse.access_token))
                    } catch {
                        print("Decoding error: \(error)")
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("API request failed: \(error)")
                    completion(.failure(error))
                }
            }
        }
        
        func getAccessToken() -> String? {
            // Retrieve the access token from the Keychain
            let accessToken = keychainHelper.get(key: "access_token")
            
            // Print the access token for debugging
            if let accessToken = accessToken {
                print("Retrieved access token: \(accessToken)")
            } else {
                print("No access token found in Keychain.")
            }
            
            return accessToken
        }

        func logout() {
            // Delete the access token from the Keychain
            keychainHelper.delete(key: "access_token")
            print("Access token deleted from Keychain.")
        }
    }

// AuthResponse model
struct AuthResponse: Decodable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let token_type: String?
}
