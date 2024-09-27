import SwiftUI
import Combine

struct CurrentWeatherView:View {
//    @SwiftUI.Environment(\.sizeData) var sizeData
    let didClickRoute = PassthroughSubject<CurrentWeatherViewRoute, Never>()
    @StateObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack(spacing: 0) {
//           Leverage sizeData data structure to check the orientation of the device and draw screen accordinlgy
//           if sizeData.isPortrait {
//
//           } else {
//                 
//           }
           switch(viewModel.state){
            case .error(let err):
                MessageView(text: err.localizedDescription, image: Image(systemName: "face.smiling"))
            case .loaded:
               ScrollView{
                   Text(viewModel.city)
                       .font(.system(size: 46))
                   LocationAndTemperatureHeaderView(data: viewModel.currentWeather)
                   
                   Spacer()
                   Rectangle().frame(height: CGFloat(1))
                   Text(viewModel.currentDescription)
                       .frame(maxWidth: .infinity, alignment: .leading)
                       .padding(
                        .init(arrayLiteral:.leading,.trailing),
                        24
                       )
                   Rectangle().frame(height: CGFloat(1))
                   DailyWeatherCellView(data: viewModel.todayWeather)
                
                   Rectangle().frame(height: CGFloat(1))
                   DetailsCurrentWeatherView(data: viewModel.currentWeather)
                   Spacer().frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                   Button(action: {
                       didClickRoute.send(.currentWeatherOtherScreen)
                   }) {
                       Text("Other Page")
                   }
               }
           case (.loading):
               ProgressView(String(localized: "loading")).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
           default:
               EmptyView()
            }
        }
        .refreshable {
            Task {
                try await viewModel.getCurrentWeatherData()
            }
        }
        .onAppear(){
            Task {
                try await viewModel.getCurrentWeatherData()
            }
        }
     }
}

#Preview {
    let apiService =  MockDataAPIService(jsonFileName: "currentWeatherData")
    let viewModel = WeatherViewModel(apiService: apiService, city: "Plano")
    return CurrentWeatherView(viewModel: viewModel)
}
