import SwiftUI
import Combine

struct ForecastWeatherView:View {
    let didClickRoute = PassthroughSubject<ForeCastWeatherViewRoute, Never>()
    @StateObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            switch(viewModel.state){
            case .error(let err):
                MessageView(text: err.localizedDescription, image: Image(systemName: "face.smiling"))
            case .loaded:
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        Text(viewModel.city)
                            .font(.system(size: 46))
                        HourlyWeatherView(data: viewModel.hourlyWeathers)
                        Rectangle().frame(height: CGFloat(1))
                        
                        DailyWeatherView(data: viewModel.dailyWeathers)
                        Rectangle().frame(height: CGFloat(1))
                    }
                    Spacer().frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                    Button(action: {
                        didClickRoute.send(.foreCastWeatherOtherScreen)
                    }) {
                        Text("Other Page")
                    }
                }
                
            case .loading:
                ProgressView(String(localized: "loading")).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            default:
                EmptyView()
            }
        }
        .refreshable {
            Task {
                try await viewModel.getForecastWeatherData()
            }
        }
        .onAppear(){
            Task {
                try await viewModel.getForecastWeatherData()
            }
        }
    }
}

#Preview {
    let apiService =  MockDataAPIService(jsonFileName: "forecastWeatherData")
    return ForecastWeatherView(viewModel:WeatherViewModel(apiService: apiService, city: "Plano"))
}
