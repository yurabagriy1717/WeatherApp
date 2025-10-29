//
//  WeatherResponse.swift
//

import Foundation

struct WeatherResponse: Decodable {
    let name: String
    let main: MainResponse
    let wind: WindResponse
    let weather: [WeatherInfoResponse]
}

struct MainResponse: Decodable {
    let temp: Double
    let feels_like: Double
    let humidity: Double
}

struct WindResponse: Decodable {
    let speed: Double
}

struct WeatherInfoResponse: Decodable {
    let description: String
    let icon: String
}

