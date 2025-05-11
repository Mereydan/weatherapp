import Foundation

enum WeatherError: Error {
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)
}

class WeatherAPI {
    private let apiKey = "YOUR_API_KEY" // Replace with your OpenWeatherMap API key
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    
    func fetchWeather(for city: String) async throws -> WeatherResponse {
        let urlString = "\(baseURL)/weather?q=\(city)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw WeatherError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(WeatherResponse.self, from: data)
        } catch let error as DecodingError {
            throw WeatherError.decodingError(error)
        } catch {
            throw WeatherError.networkError(error)
        }
    }
    
    func fetchForecast(for city: String) async throws -> ForecastResponse {
        let urlString = "\(baseURL)/forecast?q=\(city)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw WeatherError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(ForecastResponse.self, from: data)
        } catch let error as DecodingError {
            throw WeatherError.decodingError(error)
        } catch {
            throw WeatherError.networkError(error)
        }
    }
} 