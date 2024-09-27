import SwiftUI

struct HourlyWeatherView: View {
    let data: [ForecastWeather]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {               
                ForEach(data) { data in
                    HourlyWeatherCellView(data: data)
                    Spacer().frame(width: 24)
                }
            }.padding(.horizontal, 24)
        }
    }
}

#Preview {
    HourlyWeatherView(data: [ForecastWeather.emptyInit()])
}
