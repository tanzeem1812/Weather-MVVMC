import SwiftUI

struct DailyWeatherCellView: View {
    let data: ForecastWeather
    
    var day: String {
        return data.date.dateFromMilliseconds().dayWord()
    }
    
    var temperatureMax: String {
        return "\(Int(data.mainValue.tempMax))°"
    }
    
    var temperatureMin: String {
        return "\(Int(data.mainValue.tempMin))°"
    }
        
    var iconImage: UIImage {
        var imageStr = ""
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
        HStack {
            Text(day)
                .frame(width: 150, alignment: .leading)
            
            Image(uiImage: iconImage)
                .resizable()
                .aspectRatio(iconImage.size, contentMode: .fit)
                .frame(width: 30, height: 30)
            
            Spacer()
            Text(temperatureMax)
            Spacer().frame(width: 34)
            Text(temperatureMin)
        }.padding(.horizontal, 24)
    }
}

#Preview {
    DailyWeatherCellView(data: ForecastWeather.emptyInit())
}
