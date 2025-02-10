import Foundation

class SDKConfig {
    static let shared = SDKConfig()
    
    var baseURL: String = "https://api.remitlink.com"
    var clientID: String = "your-client-id"
    var clientSecret: String = "your-client-secret"

    private init() {}
}
