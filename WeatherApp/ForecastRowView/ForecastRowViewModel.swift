//
//  ForecastRowViewModel.swift
//

import Combine
import Foundation

@MainActor
final class ForecastRowViewModel: ObservableObject {
    let errorPublisher = PassthroughSubject<String, Never>()
    let loadingPublisher = CurrentValueSubject<Bool, Never>(false)


    @Published var forecastList: [ForecastItemModel] = []
    @Published var cityTimezone: Int = 0

    private let network: NetworkService
    private let forecastModelBuilder: ForecastBuildable
    
    init(
        network: NetworkService,
        forecastModelBuilder: ForecastBuildable
    ) {
        self.network = network
        self.forecastModelBuilder = forecastModelBuilder
    }
    
    private func mapForecast(serviceModel: ForecastResponse) -> ForecastModel {
        forecastModelBuilder.buildForecast(response: serviceModel)
    }

    func fetchForecast(city: String) async {
        do {
            loadingPublisher.send(true)
            let forecastServiceModel = try await network.fetchForecast(city: city)
            let forecastDomainModel = mapForecast(serviceModel: forecastServiceModel)
            await MainActor.run {
                self.forecastList = forecastDomainModel.list
                self.cityTimezone = forecastDomainModel.city.timezone
            }
            loadingPublisher.send(false)
        } catch {
            loadingPublisher.send(false)
            errorPublisher.send("не вдалося завантажити погоду: \(error.localizedDescription)")        }
    }
    
    var dailyForecast: [ForecastItemModel] {
        Dictionary(grouping: forecastList) { item in
            let date = Date(timeIntervalSince1970: TimeInterval(item.date))
            return Calendar.current.startOfDay(for: date)
        }
        .compactMap { (key:Date , items: [ForecastItemModel]) -> ForecastItemModel?  in
            guard let first = items.first else { return nil }
            
            let minTemp = items.map { $0.temperatureInfo.temp_min }.min() ?? 0
            let maxTemp = items.map { $0.temperatureInfo.temp_max }.max() ?? 0
            let avgTemp = (minTemp + maxTemp) / 2
            
            return ForecastItemModel(date: first.date,
                                     temperatureInfo: TempratureInfoModel(temp: avgTemp,
                                                                          temp_min: minTemp,
                                                                          temp_max: maxTemp),
                                     forecatDays: first.forecatDays,
                                     weatherInfo: first.weatherInfo)
        }
        .sorted { $0.date < $1.date }
    }
    
    var hourlyForecast: [ForecastItemModel] {
        let calendar = Calendar.current
        let now = Date()
        let end = calendar.date(byAdding: .hour, value: 24, to: now)!
        
        
        return forecastList.filter { item in
            let localDate = Date(timeIntervalSince1970: TimeInterval(item.date + cityTimezone))
            return localDate >= now && localDate <= end
        }
        .sorted { $0.date < $1.date }
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
