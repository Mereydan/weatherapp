import Foundation
import SwiftUI

@MainActor
class WeatherViewModel: ObservableObject {
    private let weatherAPI = WeatherAPI()
    
    @Published var currentWeather: WeatherResponse?
    @Published var forecast: ForecastResponse?
    @Published var isLoading = false
    @Published var error: String?
    
    func fetchWeather(for city: String) async {
        isLoading = true
        error = nil
        
        do {
            currentWeather = try await weatherAPI.fetchWeather(for: city)
            forecast = try await weatherAPI.fetchForecast(for: city)
        } catch WeatherError.invalidURL {
            error = "Invalid URL"
        } catch WeatherError.invalidResponse {
            error = "Invalid response from server"
        } catch WeatherError.networkError(let error) {
            error = "Network error: \(error.localizedDescription)"
        } catch WeatherError.decodingError(let error) {
            error = "Error decoding response: \(error.localizedDescription)"
        } catch {
            error = "An unexpected error occurred"
        }
        
        isLoading = false
    }
    
    func getWeatherIcon(for code: String) -> String {
        switch code {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.fill"
        case "02d": return "cloud.sun.fill"
        case "02n": return "cloud.moon.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "cloud.fill"
        case "09d", "09n": return "cloud.rain.fill"
        case "10d": return "cloud.sun.rain.fill"
        case "10n": return "cloud.moon.rain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "snow"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "questionmark.circle.fill"
        }
    }
} 