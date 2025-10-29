//
//  AppDIContainer.swift
//

import Foundation

final class AppDIContainer {
    static let shared = AppDIContainer()
    private init() {}
    
    private let network: NetworkService = NetworkServiceImpl.shared
    private let data: DataService = DefaultDataService.shared
    private let weatherModelBuilder: WeatherBuildable = WeatherBuilder.shared
    private let forecastBuilder: ForecastBuildable = ForecastBuilder.shared
    private let favouriteCityBuilder: FavouriteCityBuildable = FavouriteCityBuilder.shared

    @MainActor
    func makeWeatherViewModel() -> WeatherViewModel {
        WeatherViewModel(
            currentCardVM: makeCurrentCardViewModel(),
            forecastRowVM: makeForecastRowViewModel(),
            favouritesCityVM: makeFavouriteCityViewModel(),
        )
    }
    
    @MainActor
    func makeCurrentCardViewModel() -> CurrentCardViewModel {
        CurrentCardViewModel(network: network,
                             weatherModelBuilder: weatherModelBuilder,
                             data: data
        )
    }
    
    @MainActor
    func makeForecastRowViewModel() -> ForecastRowViewModel {
        ForecastRowViewModel(network: network,
                             forecastModelBuilder: forecastBuilder
        )
    }
    
    @MainActor
    func makeFavouriteCityViewModel() -> FavouriteCityViewModel {
        FavouriteCityViewModel(data: data,
                               network: network,
                               favouriteCityBuilder: favouriteCityBuilder)
    }
    
}
