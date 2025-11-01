//
//  CurrentCardViewModel.swift
//

import Foundation
import Combine

@MainActor
final class CurrentCardViewModel: ObservableObject {
    @Published var weatherDomainModel: WeatherModel = .empty
    @Published var savedCityName: String = ""
    
    let errorPublisher = PassthroughSubject<String, Never>()
    var loadingPublisher = CurrentValueSubject<Bool, Never>(false)

    private let network: NetworkService
    private let weatherModelBuilder: WeatherBuildable
    private let data: DataService
    

    init(
        network: NetworkService,
        weatherModelBuilder: WeatherBuildable,
        data: DataService
    ) {
        self.network = network
        self.weatherModelBuilder = weatherModelBuilder
        self.data = data
        
        self.savedCityName = data.loadLastCity() ?? "Kyiv"
        Task {
            guard !savedCityName.isEmpty else { return }
            await fetchCityWeather(city: savedCityName)
        }
    }
    
    private func mapWeather(serviceModel: WeatherResponse) -> WeatherModel {
        weatherModelBuilder.buildWeather(response: serviceModel)
    }

    func fetchCityWeather(city: String) async {
        loadingPublisher.send(true)
        do {
            let weatherServiceModel = try await network.fetchCityWeather(city: city)
            let weatherDomainModel = mapWeather(serviceModel: weatherServiceModel)
            await MainActor.run {
                self.weatherDomainModel = weatherDomainModel
                self.savedCityName = city
                data.saveLastCity(city)
            }
            loadingPublisher.send(false)
        } catch {
            loadingPublisher.send(false)
            errorPublisher.send("не вдалося завантажити погоду: \(error.localizedDescription)")
        }
    }
}
