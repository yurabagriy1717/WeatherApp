//
//  WeatherViewModel.swift
//

import SwiftUI


@MainActor
class WeatherViewModel: ObservableObject {
    @Published var showSheet: Bool = false
    @Published var showSheetFvourites: Bool = false
    @Published var city: String = "Kyiv"
    @Published var tempature: Int = 20
    @Published var feelsLike: Int = 15
    @Published var description: String = "good sunny weather really good"
    @Published var windSpeed: Int = 35
    @Published var humidity: Int = 18
    @Published var imageName: String = "cloud.bolt.rain.fill"
    @Published var query: String = ""
    @Published var forecastList: [ForecastItem] = []
    @Published var cityTimezone: Int = 0
    @Published var iconCode : String = ""
    @Published var savedCityName: String = "" {
        didSet {
            UserDefaults.standard.set(savedCityName, forKey: "lastCity")
        }
    }
    @Published var favouriteCity: [String] = [] {
        didSet {
            UserDefaults.standard.set(favouriteCity, forKey: "favouriteCity")
        }
    }

    private let apiKey = "e0491e96bc0059a2e934bd28d911bccd"
    
    init() {
        if let saved = UserDefaults.standard.string(forKey: "lastCity") {
            self.savedCityName = saved
            self.query = saved
            
            Task {
                await fetchCityWeather(city: saved)
            }
        } else {
            Task {
                await fetchCityWeather(city: "Kyiv")
            }
        }
        
        if let favouriteCity = UserDefaults.standard.array(forKey: "favouriteCity") as? [String] {
            self.favouriteCity = favouriteCity
        }
        
    }
    
    func showSheetAction() {
        showSheet = true        
    }
    
    func showSheetFavourites() {
        showSheetFvourites = true
        
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
            self.iconCode = decoded.weather.first?.icon ?? ""
            self.savedCityName = decoded.name
                        
            await fetchForecast(city: query)
            
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
    
    func fetchForecast(city: String) async {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(query)&appid=\(apiKey)&units=metric" ) else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data,response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                print("server error")
                return
            }
            
            let decoded = try JSONDecoder().decode(ForecastResponse.self, from: data)
            self.forecastList = decoded.list
            self.cityTimezone = decoded.city.timezone
            
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
        
    }
    
    func saveCity(city: String) async {
        guard let url = URL(string: "https://webhook.site/d02a9757-397c-4808-87ee-09559a55fce3") else {
            print("❌ Invalid URL")
            return
        }
        
        let newCity = FavouriteCityRequest(city: city)
        
        guard let jsonData = try? JSONEncoder().encode(newCity) else {
            print("❌ Failed to encode JSON")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        do {
            let (data,response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                print("server error")
                return
            }
            let decoded = try JSONDecoder().decode(FavouriteCityResponse.self, from: data)
            print("✅ Saved city: \(decoded.city)")
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
    
    func addCity(city: String) {
        if !favouriteCity.contains(city) {
            favouriteCity.append(city)
            print("✅ Added \(city) to favorites")
        }
    }
    
    func removeCity(city: String) {
        if let index = favouriteCity.firstIndex(of: city) {
            favouriteCity.remove(at: index)
            print("✅ Removed \(city) from favorites")
        }
    }
    
    func removeCity(at offsets: IndexSet) {
        offsets.map { favouriteCity[$0] }.forEach { city in
            removeCity(city: city)
        }
    }
    
    var weatherIconURL: URL? {
        guard !iconCode.isEmpty else { return nil }
        return URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png")
    }
    
    var dailyForecast: [ForecastItem] {
        Dictionary(grouping: forecastList) { item in
            let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
            return Calendar.current.startOfDay(for: date)
        }
        .compactMap { (key:Date , items: [ForecastItem]) -> ForecastItem?  in
            guard let first = items.first else { return nil }
            
            let minTemp = items.map { $0.main.temp_min }.min() ?? 0
            let maxTemp = items.map { $0.main.temp_max }.max() ?? 0
            let avgTemp = (minTemp + maxTemp) / 2

            return ForecastItem(
                dt: first.dt ,
                main: ForecastMain(temp: avgTemp, temp_min: minTemp, temp_max: maxTemp), dt_txt: first.dt_txt, weather: first.weather
            )
        }
        .sorted { $0.dt < $1.dt }
    }
    
    var hourlyForecast: [ForecastItem] {
        let calendar = Calendar.current
        let now = Date()
        let end = calendar.date(byAdding: .hour, value: 24, to: now)!

        
        return forecastList.filter { item in
            let localDate = Date(timeIntervalSince1970: TimeInterval(item.dt + cityTimezone))
            return localDate >= now && localDate <= end
        }
        .sorted { $0.dt < $1.dt }
    }
    
    func formatHour(from dateString: String) -> String {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
           formatter.timeZone = TimeZone(secondsFromGMT: 0)
           guard let date = formatter.date(from: dateString) else { return "--" }
        
            let localDate = date.addingTimeInterval(TimeInterval(cityTimezone))
           formatter.timeZone = .current
           formatter.dateFormat = "HH:mm"
           return formatter.string(from: localDate)
       }
}



