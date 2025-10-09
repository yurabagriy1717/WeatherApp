//
//  WeatherModels.swift
//

import Foundation

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

struct ForecastResponse: Codable {
    let list: [ForecastItem]
    let city: City
}

struct City: Codable {
    let timezone: Int
}

struct ForecastItem: Codable, Identifiable {
    var id = UUID()
    let dt: Int
    let main: ForecastMain
    let dt_txt: String
    let weather: [Weather]
    
    private enum CodingKeys: String, CodingKey {
            case dt, main, dt_txt, weather
        }
}

extension ForecastItem {
    var iconURL: URL? {
        guard let code = weather.first?.icon else { return nil }
        return URL(string: "https://openweathermap.org/img/wn/\(code)@2x.png")
    }
}

struct ForecastMain: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}
