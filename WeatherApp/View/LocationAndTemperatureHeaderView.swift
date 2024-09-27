import SwiftUI

struct LocationAndTemperatureHeaderView: View {
    let data: CurrentWeather

    var weatherName: String {
        var result = ""
        if let weather = data.elements.first {
            result = weather.main
        }
        return result
    }
    
    var temperature: String {
        return "\(Int(data.mainValue.temp))°"
    }

    var body: some View {
        HStack {
            Text(temperature)
                .font(.system(size: 86))
            Text(weatherName)
                .font(.system(size: 26))
              
        }
        .fontWeight(.thin)
        .padding(.vertical, 4)
    }
}

#Preview {
    LocationAndTemperatureHeaderView(data: CurrentWeather.emptyInit())
}
