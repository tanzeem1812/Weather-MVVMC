import Foundation

struct EndpointsBuilder {
   
    private enum SuffixURL: String {
        case forecast
        case weather
    }
    
    static private func baseUrl(_ suffixURL: SuffixURL) -> URL? {
        if let baseURL = Environment.baseURL, let apiKey =  Environment.apiKey  {
            if let url = URL(string: "\(baseURL)/\(suffixURL.rawValue)?APPID=\(apiKey)") {
                return url
            }
        }
        return nil
    }
    
    
    static func buildForeCasetWeatherURL(latitude: Double, longitude: Double) -> String? {
        if let url = EndpointsBuilder.baseUrl(SuffixURL.forecast) {
            return buildURL(url:url, latitude:latitude, longitude:longitude)
        }
        return nil
    }
    
    static func buildCurrentWeatherURL(latitude: Double, longitude: Double) -> String? {
        if let url = EndpointsBuilder.baseUrl(SuffixURL.weather) {
            return  buildURL(url:url, latitude:latitude, longitude:longitude)
        }
        return nil
    }
    
    private static func buildURL(url:URL,latitude:Double, longitude:Double) ->String {
        let urlStr = "\(url)&lat=\(latitude)&lon=\(longitude)&exclude=minutely&units=metric"
        return urlStr
    }
}
