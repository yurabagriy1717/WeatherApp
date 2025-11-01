//
//  WeatherViewModel.swift
//

import Combine
import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
    
    let errorPublisher = PassthroughSubject<String, Never>()
    let loadingPublisher = CurrentValueSubject<Bool, Never>(false)
    
    @Published var showSheet: Bool = false
    @Published var showSheetFvourites: Bool = false
    @Published var query: String = ""
    
    let currentCardVM: CurrentCardViewModel
    let forecastRowVM: ForecastRowViewModel
    let favouritesCityVM: FavouriteCityViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    init (
         currentCardVM: CurrentCardViewModel,
         forecastRowVM: ForecastRowViewModel,
         favouritesCityVM: FavouriteCityViewModel
    ) {
        self.currentCardVM = currentCardVM
        self.forecastRowVM = forecastRowVM
        self.favouritesCityVM = favouritesCityVM
        
        bindChildViewModels()
        setupSearchBinding()
    }
    
    func showSheetAction() {
        showSheet = true
    }
    
    func showSheetFavourites() {
        showSheetFvourites = true
    }
    
    private func bindChildViewModels() {             
        currentCardVM.errorPublisher
            .merge(with: forecastRowVM.errorPublisher)
            .sink { [weak self] message in
                self?.errorPublisher.send(message)
            }
                .store(in: &cancellables)
        
        currentCardVM.loadingPublisher
            .merge(with: forecastRowVM.loadingPublisher)
            .sink { [weak self] isLoading in
                self?.loadingPublisher.send(isLoading)
            }
               .store(in: &cancellables)
    }
    
    func setupSearchBinding() {
        $query
            .debounce(for: .milliseconds(1000), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                Task { await self?.searchCity() }
            }
            .store(in: &cancellables)
    }
    
    func searchCity() async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return
        }
        loadingPublisher.send(true)
        await currentCardVM.fetchCityWeather(city: query)
        await forecastRowVM.fetchForecast(city: query)
        loadingPublisher.send(false)
    }
    
}



