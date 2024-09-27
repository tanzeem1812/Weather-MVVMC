import XCTest
import CoreLocation
@testable import WeatherApp

final class ViewModelTest: XCTestCase {
  
    override func setUpWithError() throws {
    }
    
    func testViewModelMockData() async throws {
        let apiService = MockDataAPIService(jsonFileName: "forecastWeatherData")
        let viewModel = WeatherViewModel(apiService: apiService, city: "Florida")
        try await viewModel.getForecastWeatherData()
        XCTAssertTrue(viewModel.dailyWeathers.count > 0)
    }
    
    func testViewModelMockDataError()  async throws {
        let apiService = MockDataAPIErrorService()
        let viewModel = WeatherViewModel(apiService:apiService, city: "Plano")
        do {
            try await viewModel.getForecastWeatherData()
        }
        catch (let err as AppError){
            XCTAssertEqual(err, AppError.serverError)
        }
     }
    
    func testViewModelMockDataUsingServiceObject() async throws {
        let viewModel =  WeatherViewModel(apiService:MockDataAPIService(jsonFileName: "forecastWeatherData"), city: "Chicago")
        do {
            if let url = URL(string: "dummyURL"){
                let data = try await viewModel.apiService.fetchDataRequest(url: url) as ForecastWeatherResponse
                XCTAssertTrue(data.dailyList.count > 0 )
            } else {
                XCTFail("testViewModelMockDataUsingServiceObject -  invalid url")
            }
        }
        catch { }
    }
    
    func testWeatherDataAPI() async throws {
        let viewModel =  WeatherViewModel(apiService:DataTaskAPIService.shared,city: "New York")
        try await viewModel.getForecastWeatherData()
        XCTAssertTrue(viewModel.dailyWeathers.count > 0)
    }
    
    func testViewModelMockDataErrorUsingServiceObject()  async throws {
        let viewModel =  WeatherViewModel(apiService:MockDataAPIErrorService(), city: "New Jersy")
        do {
            if let url = URL(string: "dummyURL") {
                _ = try await viewModel.apiService.fetchDataRequest(url: url) as ForecastWeatherResponse
            } else {
                XCTFail("testViewModelMockDataErrorUsingServiceObject - invalid url")
            }
        }
        catch (let err as AppError){
            XCTAssertEqual(err, AppError.serverError)
        }
    }
    
    // Add more relevant Viewmodel test cases 
}
