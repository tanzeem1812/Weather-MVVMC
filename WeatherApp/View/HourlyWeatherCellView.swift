import SwiftUI

struct HourlyWeatherCellView: View {
    var data: ForecastWeather

    var hour: String {
        return data.date.dateFromMilliseconds().hour()
    }

    var temperature: String {
        return "\(Int(data.mainValue.temp))°"
    }
    
    var iconImage: UIImage {
        var imageStr = "WeatherIcon"
        if let weather = data.elements.first {
            imageStr = weather.icon
        }
        if let uiImage = UIImage(named: imageStr) {
            return uiImage
        } else {
            return UIImage(named: "WeatherIcon")!
        }
    }

    var body: some View {
        VStack {
            Text(hour)
            Text("\(data.mainValue.humidity)%")
                .font(.system(size: 12))
            Image(uiImage: iconImage)
                .resizable()
                .aspectRatio(iconImage.size, contentMode: .fit)
                .frame(width: 30, height: 30)
            Text(temperature)
        }.padding(.all, 0)
    }
}

#Preview {
    HourlyWeatherCellView(data: ForecastWeather.emptyInit())
}
