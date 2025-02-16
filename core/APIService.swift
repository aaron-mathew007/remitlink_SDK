
import Foundation

class APIService {
    static let shared = APIService()
    private let session: URLSession
    private var accessToken: String?

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        session = URLSession(configuration: configuration)
    }

    func makeRequest(endpoint: String, method: String, headers: [String: String]?, body: [String: Any]?, bodyData: Data? = nil, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: SDKConfig.shared.baseURL + endpoint) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers

        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(.failure(error))
                return
            }
        }

        if let bodyData = bodyData {
            request.httpBody = bodyData
        }

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "InvalidResponse", code: -2, userInfo: nil)))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil)))
                return
            }

            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NSError(domain: "NoData", code: -3, userInfo: nil)))
            }
        }.resume()
    }
}
