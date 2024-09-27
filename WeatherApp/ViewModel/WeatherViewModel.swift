import SwiftUI
import CoreLocation

final class WeatherViewModel: ObservableObject {
    var apiService:APIService
    @Published var state: ViewState = .idle
    var hourlyWeathers: [ForecastWeather] = []
    var dailyWeathers: [ForecastWeather] = []
    var currentWeather = CurrentWeather.emptyInit()
    var todayWeather = ForecastWeather.emptyInit()
    var currentDescription = ""
    let city:String
    
    init(apiService: APIService, city:String) {
        self.apiService = apiService
        self.city = city
    }
    
    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case error(AppError)
    }
    
    let errorclosure  = {
        throw AppError.unknown
    }
    
    func getForecastWeatherData() async throws {
        do {
            let coord = try await getCoordinates(from: city)
            try await self.fetchForeCastWeatherData(coord: coord)
        } catch {
            changeState(state:.error(.geoCodeError))
        }
    }
    
    func fetchForeCastWeatherData(coord:CLLocationCoordinate2D) async throws {
        if let urlStr = EndpointsBuilder.buildForeCasetWeatherURL(latitude: coord.latitude, longitude: coord.longitude) {
            if let url = URL(string: urlStr)  {
                do {
                    changeState(state: .loading)
                    let foreCastWeatherData =  try await (apiService.fetchDataRequest(url: url)) as ForecastWeatherResponse
                    
                    self.hourlyWeathers = foreCastWeatherData.list
                    self.dailyWeathers = foreCastWeatherData.dailyList
                    changeState(state: .loaded)
                } catch (let err as AppError) {
                    changeState(state: .error(err))
                }
            }else {
                changeState(state: .error(.invalidUrl))
            }
        }
        else {
            changeState(state: .error(.invalidUrl))
        }
    }
    
    func getCurrentWeatherData() async throws {
        do {
            let coords = try await getCoordinates(from: city)
            try await self.getCurrentWeatherForCords(coords: coords)
        }
        catch{
            changeState(state: .error(.geoCodeError))
        }
    }
    
    private func getCurrentWeatherForCords(coords: CLLocationCoordinate2D?) async throws {
        if let coords = coords {
            guard let urlStr = EndpointsBuilder.buildCurrentWeatherURL(latitude: coords.latitude, longitude: coords.longitude) else {
                changeState(state:.error(.invalidUrl))
                return
            }
            try await fetchCurrentWeatherData(for: urlStr)
        } else {
            changeState(state:.error(.geoCodeError))
        }
    }
    
    func fetchCurrentWeatherData(for urlStr: String) async throws {
        if let url = URL(string: urlStr)  {
            do {
                changeState(state:.loading)
                let currentWeatherData =  try await (apiService.fetchDataRequest(url: url)) as CurrentWeather
                self.currentWeather = currentWeatherData
                self.todayWeather = currentWeather.getForecastWeather()
                self.currentDescription = currentWeather.description()
                changeState(state:.loaded)
            } catch (let err as AppError) {
                changeState(state:.error(err))
            }
        }else {
            changeState(state:.error(.invalidUrl))
        }
    }
    
    func changeState(state:ViewState) {
        Task { @MainActor in
            self.state = state
        }
    }
    
    func getCoordinates(from address: String) async throws ->  CLLocationCoordinate2D {
        let geocoder = CLGeocoder()
        
        guard let location = try await geocoder.geocodeAddressString(address)
            .compactMap( { $0.location } )
            .first(where: { $0.horizontalAccuracy >= 0 } )
        else {
            throw CLError(.geocodeFoundNoResult)
        }
        return location.coordinate
    }
}


