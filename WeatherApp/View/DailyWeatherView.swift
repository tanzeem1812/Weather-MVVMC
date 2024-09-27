import SwiftUI

struct DailyWeatherView: View {
    let data: [ForecastWeather]
    
    var body: some View {
        VStack {
            ForEach(data, id: \.date) { data in
                DailyWeatherCellView(data: data)
            }
        }
    }
}

#Preview {
    DailyWeatherView(data: [ForecastWeather.emptyInit()])
}

