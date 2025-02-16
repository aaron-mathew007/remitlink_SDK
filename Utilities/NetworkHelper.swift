import Foundation

class NetworkHelper {
    static let baseURL = "https://drap-sandbox.digitnine.com"

    static func createURL(endpoint: String) -> URL? {
        return URL(string: baseURL + endpoint)
    }
}
