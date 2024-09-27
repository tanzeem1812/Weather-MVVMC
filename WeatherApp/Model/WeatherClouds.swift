import Foundation

struct WeatherClouds: Codable {
    let all: Int

    static func emptyInit() -> WeatherClouds {
        return WeatherClouds(all: 0)
    }
}
