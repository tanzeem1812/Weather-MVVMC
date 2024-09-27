import XCTest
@testable import WeatherApp

final class DataTaskAPIServiceTests: XCTestCase {
    var apiService:APIService = DataTaskAPIService.shared
    
    func testAPIKey(){
        let apiKey = Environment.apiKey
        XCTAssertNotNil(apiKey)
    }
    
    func testBaseURL(){
        let baseURLStr = Environment.baseURL
        XCTAssertNotNil(baseURLStr)
    }
    
    func testForeCastWeatherDataAPI() async throws {
        if let urlStr = EndpointsBuilder.buildForeCasetWeatherURL(latitude: 33.7482, longitude: -84.3909) {
            if let url = URL(string:urlStr) {
                do {
                    let data = try await apiService.fetchDataRequest(url: url) as ForecastWeatherResponse
                    XCTAssertTrue(data.dailyList.count > 0 )
                } catch(let err as AppError) {
                    XCTFail("testForeCastWeatherDataAPI failed - \(err.localizedDescription))")
                }
            } else {
                XCTFail ("testWeatherDataAPI failed - invalid url")
            }
        } else {
            XCTFail ("testWeatherDataAPI failed - invalid url ")
        }
    }
}

