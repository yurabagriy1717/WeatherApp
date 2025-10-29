//
//  WeatherBuilder.swift
//

import Foundation

protocol WeatherBuildable{
    func buildWeather(response: WeatherResponse) -> WeatherModel
}

class WeatherBuilder: WeatherBuildable {
    static let shared = WeatherBuilder()

    func buildWeather(response: WeatherResponse) -> WeatherModel {
        WeatherModel(cityName: response.name,
                     temperature: Int(response.main.temp),
                     feelsLike: Int(response.main.feels_like),
                     humidity: Int(response.main.humidity),
                     windSpeed: Int(response.wind.speed),
                     description: response.weather.first?.description.capitalized ?? "No data",
                     iconCode: response.weather.first?.icon ?? "")
    }
}

