//
//  NetworkService.swift
//

import Foundation
protocol NetworkService {
    func fetchCityWeather(city: String) async throws -> WeatherResponse
    func fetchForecast(city: String) async throws -> ForecastResponse
    func saveCity(city: String) async throws -> FavouriteCityResponse
}

final class NetworkServiceImpl: NetworkService {
    static let shared = NetworkServiceImpl()
    private init() {}
    
    private let apiKey = "e0491e96bc0059a2e934bd28d911bccd"
    
    func fetchCityWeather(city: String) async throws -> WeatherResponse {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
    
    func fetchForecast(city: String) async throws -> ForecastResponse {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)&units=metric" ) else {
            throw URLError(.badURL)
        }
        let (data,response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(ForecastResponse.self, from: data)
    }
    
    func saveCity(city: String) async throws -> FavouriteCityResponse {
        guard let url = URL(string: "https://webhook.site/b81c7f43-532c-4be5-b9d6-95ea05a3d980") else {
            throw URLError(.badURL)
        }
        
        let body = FavouriteCityRequest(city: city)
        let jsonData = try JSONEncoder().encode(body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data,response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        makeAdditionalPrediction()
        
        return try JSONDecoder().decode(FavouriteCityResponse.self, from: data)
    }
    
    func makeAdditionalPrediction() {
        //.....
    }
}

