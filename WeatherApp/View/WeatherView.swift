import SwiftUI
import Combine

enum WeatherViewRoute {
    case currentWeather(String)
    case forecastWeather(String)
}

struct WeatherView: View {
    @StateObject private var locationManager = LocationManager()
    let didClickHomeViewMenuItem = PassthroughSubject<WeatherViewRoute, Never>()
    @State var city:String = ""
    let minCityChars = 4
    
    var body: some View {
        VStack(spacing: 0) {
            switch locationManager.authorizationStatus {
            case .notDetermined:
                ProgressView()
            case .restricted:
                MessageView(text: String(localized:"locationRestricted"), image: Image(systemName: "face.smiling"))
            case .denied:
                MessageView(text: String(localized: "enableLocationPermisssion"), image: Image(systemName: "face.smiling"))
            case .authorizedAlways, .authorizedWhenInUse:
                Spacer()
                TextField(String(localized:"enterCityName"), text: $city)
                    .padding(.all, 15)
                    .font(.system(size: Font.smallSize))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                    .padding(.all, 15)
                NavigationView {
                    List {
                        Button(action: {
                            didClickHomeViewMenuItem.send(.currentWeather(city))
                        }) {
                            Text(String(localized:"currentWeather"))
                        }
                        Button(action: {
                            didClickHomeViewMenuItem.send(.forecastWeather(city))
                        }) {
                            Text(String(localized:"forecastWeather"))
                        }
                    }
                    .listStyle(.plain)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
                .padding(.all, 0)
                .disabled(city.trimSpacesFromString().count < minCityChars)
                .onAppear(){
                    Task {
                        city = await AppDataStoreService.getAppData().city
                        if city.isEmpty {
                            city = "New York" // default city name
                        }
                    }
                }
                .onDisappear(){
                    storeCity()
                }
                Spacer()
            default:
                EmptyView()
            }
        }
        .onAppear(){
            locationManager.requestPermission()
        }
    }
    
    func storeCity(){
        AppDataStoreService.saveAppdata(appData: AppData(city: city))
    }
}


