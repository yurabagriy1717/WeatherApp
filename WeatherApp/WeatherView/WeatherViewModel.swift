//
//  WeatherViewModel.swift
//

import SwiftUI


@MainActor
class WeatherViewModel: ObservableObject {
    @Published var showSheet: Bool = false
    @Published var city: String = "Kyiv"
    @Published var tempature: Int = 20
    @Published var feelsLike: Int = 15
    @Published var description: String = "good sunny weather really good"
    @Published var windSpeed: Int = 35
    @Published var humidity: Int = 18
    @Published var imageName: String = "cloud.bolt.rain.fill"
    @Published var query: String = ""
    
    private let apiKey = "e0491e96bc0059a2e934bd28d911bccd"
    
    func showSheetAction() {
        showSheet = true
    }
    
    func fetchCityWeather(city: String) async {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(query)&appid=\(apiKey)&units=metric") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                print("server error")
                return
            }
            
            let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
            
            self.city = decoded.name
            self.tempature = Int(decoded.main.temp)
            self.feelsLike = Int(decoded.main.feels_like)
            self.humidity = Int(decoded.main.humidity)
            self.description = decoded.weather.first?.description.capitalized ?? "No data"
            self.windSpeed = Int(decoded.wind.speed)
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
}

struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let wind: Wind
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let humidity: Double
}

struct Wind: Codable {
    let speed: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}
