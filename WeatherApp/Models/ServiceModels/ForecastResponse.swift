//
//  ForecastResponse.swift
//

import Foundation

struct TestServiceModel: Decodable {
    let news_today: String
    let best_seller: String
}

struct ForecastResponse: Decodable {
    let list: [ForecastItemResponse]
    let city: CityResponse
}

struct CityResponse: Decodable {
    let timezone: Int
}

struct ForecastItemResponse: Decodable {
    let dt: Int
    let main: ForecastMain
    let dt_txt: String
    let weather: [WeatherInfoResponse]
}

struct ForecastMain: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

extension ForecastItemResponse {
    var iconURL: URL? {
        guard let code = weather.first?.icon else { return nil }
        return URL(string: "https://openweathermap.org/img/wn/\(code)@2x.png")
    }
}
