//
//  ForcecastModel.swift
// 

import Foundation

struct TestDomainModel: Identifiable {
    let id = UUID()
    let newsToday: String
    let bestSeller: String
}

struct ForecastModel {
    let list: [ForecastItemModel]
    let city: CityModel
}

struct CityModel {
    let timezone: Int
}

struct ForecastItemModel: Identifiable {
    let id = UUID()
    let date: Int
    let temperatureInfo: TempratureInfoModel
    let forecatDays: String
    let weatherInfo: [WeatherInfoModel]
    
    var iconURL: URL? {
            guard let icon = weatherInfo.first?.icon else { return nil }
            return URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
        }
}

struct TempratureInfoModel {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

struct WeatherInfoModel {
    let description: String
    let icon: String
}
