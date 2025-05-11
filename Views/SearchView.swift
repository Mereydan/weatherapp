import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var viewModel: WeatherViewModel
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            TextField("Enter city name", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onSubmit {
                    Task {
                        await viewModel.fetchWeather(for: searchText)
                    }
                }
            
            if viewModel.isLoading {
                ProgressView()
            } else if let weather = viewModel.currentWeather {
                NavigationLink(destination: WeatherDetailView(weather: weather)) {
                    WeatherRowView(weather: weather)
                }
            }
            
            if let error = viewModel.error {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .navigationTitle("WeatherNow")
    }
}

struct WeatherRowView: View {
    let weather: WeatherResponse
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(weather.name)
                    .font(.headline)
                Text("\(Int(round(weather.main.temp)))°C")
                    .font(.title)
            }
            
            Spacer()
            
            if let weatherCondition = weather.weather.first {
                Image(systemName: "sun.max.fill") // This will be replaced with dynamic icons
                    .font(.title)
            }
        }
        .padding()
    }
}

#Preview {
    SearchView()
        .environmentObject(WeatherViewModel())
} 