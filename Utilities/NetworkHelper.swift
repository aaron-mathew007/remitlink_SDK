import Foundation

class NetworkHelper {
    static func createURL(endpoint: String) -> URL? {
        guard let baseURL = URL(string: SDKConfig.shared.baseURL) else {
            return nil
        }
        return baseURL.appendingPathComponent(endpoint)
    }
}
