import SwiftUI

struct WeatherDetailView: View {
    let weather: WeatherResponse
    @EnvironmentObject private var viewModel: WeatherViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // City and Temperature
                VStack {
                    Text(weather.name)
                        .font(.largeTitle)
                        .bold()
                    
                    if let weatherCondition = weather.weather.first {
                        Text("\(Int(round(weather.main.temp)))°C")
                            .font(.system(size: 70))
                            .bold()
                        
                        Text(weatherCondition.description.capitalized)
                            .font(.title2)
                        
                        Image(systemName: viewModel.getWeatherIcon(for: weatherCondition.icon))
                            .font(.system(size: 60))
                            .foregroundColor(.yellow)
                    }
                }
                .padding()
                
                // Weather Details
                VStack(spacing: 15) {
                    WeatherDetailRow(icon: "humidity", title: "Humidity", value: "\(weather.main.humidity)%")
                    WeatherDetailRow(icon: "wind", title: "Wind Speed", value: "\(Int(round(weather.wind.speed))) m/s")
                    WeatherDetailRow(icon: "gauge", title: "Pressure", value: "\(weather.main.pressure) hPa")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal)
                
                // Forecast Section
                if let forecast = viewModel.forecast {
                    VStack(alignment: .leading) {
                        Text("5-Day Forecast")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(forecast.list.prefix(5), id: \.dt) { item in
                                    ForecastDayView(item: item, viewModel: viewModel)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    Task {
                        await viewModel.fetchWeather(for: weather.name)
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
}

struct WeatherDetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 30)
            Text(title)
            Spacer()
            Text(value)
                .bold()
        }
        .padding(.horizontal)
    }
}

struct ForecastDayView: View {
    let item: ForecastResponse.ForecastItem
    let viewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            Text(formatDate(item.dt))
                .font(.caption)
            
            if let weather = item.weather.first {
                Image(systemName: viewModel.getWeatherIcon(for: weather.icon))
                    .font(.title2)
            }
            
            Text("\(Int(round(item.main.temp)))°")
                .font(.title3)
                .bold()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private func formatDate(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationView {
        WeatherDetailView(weather: WeatherResponse(
            weather: [WeatherResponse.Weather(id: 800, main: "Clear", description: "clear sky", icon: "01d")],
            main: WeatherResponse.Main(temp: 20, humidity: 65, pressure: 1013),
            wind: WeatherResponse.Wind(speed: 5.0),
            name: "London"
        ))
        .environmentObject(WeatherViewModel())
    }
} 