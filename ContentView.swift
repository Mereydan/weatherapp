import SwiftUI

struct ContentView: View {
    @StateObject private var weatherViewModel = WeatherViewModel()
    
    var body: some View {
        NavigationView {
            SearchView()
                .environmentObject(weatherViewModel)
        }
    }
}

#Preview {
    ContentView()
} 