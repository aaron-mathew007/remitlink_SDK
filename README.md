
RemitLinkSDK in Swift language 



SDK Documentation

Overview
This SDK is designed to streamline interactions with your platform by providing a set of
tools and functionalities organized into core groups: Core, Models, Utilities, and
Configuration. Below is a breakdown of the SDK components and their respective
responsibilities.


Group Breakdown

Core
The Core group includes the foundational components that drive the SDK’s primary
functionalities:

APIService
 Description: Responsible for handling all API-related communication.
 Features:
o Send HTTP requests to the server.
o Handle response parsing and error management.
o Provide retry logic and timeout handling.
 Key Methods:
o func sendRequest(endpoint: String, method: HttpMethod,
parameters: [String: Any]?) -&gt; Result&lt;T&gt;
o func cancelAllRequests()

AuthenticationManager
 Description: Manages user authentication and session lifecycle.
 Features:
o Token generation and refresh handling.
o Secure storage of authentication credentials.
o Logout functionality.
 Key Methods:
o func login(username: String, password: String) -&gt; Bool
o func refreshToken() -&gt; Bool
o func logout()


Models
The Models group represents the data structures used by the SDK:

Quote
 Description: Represents a financial quote object.
 Properties:
o id: String
o price: Double
o currency: String
o timestamp: Date
 Methods:
o func toJSON() -&gt; [String: Any]

Transaction
 Description: Represents a transaction object within the system.
 Properties:
o id: String
o amount: Double
o status: String
o date: Date
 Methods:
o func toJSON() -&gt; [String: Any]



Utilities
The Utilities group provides helper classes for common tasks:

JsonParser
 Description: Simplifies JSON parsing and serialization.
 Key Methods:
o func parse&lt;T: Decodable&gt;(_ json: Data, to type: T.Type) -&gt; T?
o func serialize&lt;T: Encodable&gt;(_ object: T) -&gt; Data?

NetworkHelper
 Description: Provides utility functions for network operations.
 Features:
o Internet connection checks.
o Network status monitoring.
 Key Methods:
o func isConnectedToInternet() -&gt; Bool
o func monitorNetworkStatus(callback: (Bool) -&gt; Void)

Configuration
The Configuration group allows the SDK to be customized based on your requirements:

SDKConfig
 Description: Centralized configuration for the SDK.
 Properties:
o baseURL: String
o timeoutInterval: TimeInterval
o defaultHeaders: [String: String]
 Key Methods:
o init(baseURL: String, timeoutInterval: TimeInterval,
defaultHeaders: [String: String])

Installation
To integrate this SDK into your project:
1. Add the SDK files to your Xcode project.
2. Configure the SDK by initializing the SDKConfig object with your desired settings.
3. Use the components within the groups as needed.

Example Usage
Initialize the SDK
let config = SDKConfig(baseURL: &quot;https://api.example.com&quot;, timeoutInterval:
30.0, defaultHeaders: [&quot;Authorization&quot;: &quot;Bearer token&quot;])
Send a Request Using APIService
let apiService = APIService()
apiService.sendRequest(endpoint: &quot;/quotes&quot;, method: .get, parameters: nil)
{ result in
switch result {
case .success(let data):
print(&quot;Success: \(data)&quot;)
case .failure(let error):
print(&quot;Error: \(error.localizedDescription)&quot;)
}
}
Parse JSON with JsonParser
let jsonData = ... // Some JSON data
if let quote: Quote = JsonParser().parse(jsonData, to: Quote.self) {
print(&quot;Quote ID: \(quote.id)&quot;)
}



Testing
 Unit Testing: Ensure all components (e.g., APIService, AuthenticationManager)
are thoroughly tested using mock data and stubs.

 Integration Testing: Test end-to-end workflows to confirm compatibility with your
backend services.

Future Enhancements
1. Add support for caching responses in APIService.
2. Expand the Models group to include additional entities as required.
3. Provide Swift Package Manager (SPM) support for easier integration.
4. Enhance error-handling mechanisms for better developer experience.



Conclusion
This SDK is structured to provide flexibility, scalability, and ease of use. Feel free to
customize the components to suit your project needs. For further assistance, contact the SDK
development team or refer to the documentation included in the repository.

