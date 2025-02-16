import Foundation

class SDKConfig {
    static let shared = SDKConfig()
    let baseURL = "https://drap-sandbox.digitnine.com"
    var clientID: String = "cdp_app"
    var clientSecret: String = "mSh18BPiMZeQqFfOvWhgv8wzvnNVbj3Y"

    private init() {}
}
