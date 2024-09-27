import XCTest
@testable import WeatherApp

final class MockAPITests: XCTestCase {
    
    override func setUpWithError() throws {
    }
    
    func testMockDataAPIData() async throws {
        if let url = URL(string: "dummyURL") {
            do {
                let data = try await MockDataAPIService(jsonFileName: "forecastWeatherData").fetchDataRequest(url: url) as ForecastWeatherResponse
                XCTAssertTrue(data.list.count > 0 )
            } catch { }
        } else {
            XCTFail("testMockDataAPIData failed - invalid url ")
        }
    }
    
    func testMockDataAPIError()  async throws {
        if let url = URL(string: "dummyURL") {
            do {
                _ = try await MockDataAPIErrorService().fetchDataRequest(url:url) as ForecastWeatherResponse
            } catch (let err as AppError) {
                XCTAssertEqual(err, AppError.serverError)
            }
        } else {
            XCTFail("testMockDataAPIError failed - invalid url")
        }
    }
}
