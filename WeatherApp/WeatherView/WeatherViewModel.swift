//
//  WeatherViewModel.swift
//

import Combine
import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var showSheet: Bool = false
    @Published var showSheetFvourites: Bool = false
    @Published var query: String = ""
    
    let currentCardVM: CurrentCardViewModel
    let forecastRowVM: ForecastRowViewModel
    let favouritesCityVM: FavouriteCityViewModel
    
    init (
         currentCardVM: CurrentCardViewModel,
         forecastRowVM: ForecastRowViewModel,
         favouritesCityVM: FavouriteCityViewModel
    ) {
        self.currentCardVM = currentCardVM
        self.forecastRowVM = forecastRowVM
        self.favouritesCityVM = favouritesCityVM
    }
    
    func showSheetAction() {
        showSheet = true
    }
    
    func showSheetFavourites() {
        showSheetFvourites = true
    }
    
    func searchCity() async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return
        }
        await currentCardVM.fetchCityWeather(city: query)
        await forecastRowVM.fetchForecast(city: query)
    }
    
}



