import Foundation

class JSONParser {
    static func decode<T: Decodable>(_ data: Data, to type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("JSON Decoding Error: \(error.localizedDescription)")
            throw error
        }
    }

    static func encode<T: Encodable>(_ object: T) throws -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        do {
            return try encoder.encode(object)
        } catch {
            print("JSON Encoding Error: \(error.localizedDescription)")
            throw error
        }
    }
}
