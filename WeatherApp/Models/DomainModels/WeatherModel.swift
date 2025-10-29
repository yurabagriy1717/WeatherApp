//
//  WeatherModel.swift
//

import Foundation

struct WeatherModel {
    let cityName: String
    let temperature: Int
    let feelsLike: Int
    let humidity: Int
    let windSpeed: Int
    let description: String
    let iconCode: String
    var iconURL: URL? {
        guard !iconCode.isEmpty else { return nil }
        return URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png")
    }
    
    static let empty = WeatherModel(
            cityName: "",
            temperature: 0,
            feelsLike: 0,
            humidity: 0,
            windSpeed: 0,
            description: "",
            iconCode: ""
        )
}
