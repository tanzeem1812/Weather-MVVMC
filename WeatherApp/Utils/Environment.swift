import Foundation

public enum Environment {
    enum Keys {
        static let apiKey = "API_KEY"
        static let baseUrl = "BASE_URL"
    }
    
    private static let infoDictionary:[String:Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError(String(localized: "plistNotFound"))
        }
        return dict
    }()
    
    static let baseURL:String? = {
        guard let baseURLString = infoDictionary[Keys.baseUrl] as? String else {
            return nil
        }
        return baseURLString
    }()
    
    static let apiKey:String? = {
        guard let apiKeyStr = infoDictionary[Keys.apiKey] as? String else {
            return nil
        }
        return apiKeyStr
    }()
}
