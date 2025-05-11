import Foundation

struct WeatherResponse: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Codable {
        let temp: Double
        let humidity: Int
        let pressure: Int
    }
    
    struct Wind: Codable {
        let speed: Double
    }
}

struct ForecastResponse: Codable {
    let list: [ForecastItem]
    
    struct ForecastItem: Codable {
        let dt: TimeInterval
        let main: WeatherResponse.Main
        let weather: [WeatherResponse.Weather]
    }
} 