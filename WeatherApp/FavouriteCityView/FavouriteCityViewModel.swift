//
//  FavouriteCityViewModel.swift
//

import Combine
import Foundation

@MainActor
final class FavouriteCityViewModel: ObservableObject {
    @Published var favouriteCity: [String] = [] {
        didSet {
            data.saveFavouriteCities(favouriteCity)
        }
    }

    private let data: DataService
    private let network: NetworkService
    private let favouriteCityBuilder: FavouriteCityBuildable
    
    init(
        data: DataService,
        network: NetworkService,
        favouriteCityBuilder: FavouriteCityBuildable
    ) {
        self.data = data
        self.network = network
        self.favouriteCityBuilder = favouriteCityBuilder
        
        self.favouriteCity = data.loadFavouriteCities()
    }
        
    private func mapFavouriteCity(serviceModel: FavouriteCityResponse) -> FavouriteCityModel {
        favouriteCityBuilder.buildFavouriteCity(response: serviceModel)
    }

    func addCity(city: String) {
        if !favouriteCity.contains(city) {
            favouriteCity.append(city)
            print("✅ Added \(city) to favorites")
        }
        Task {
            await saveCity(city: city)
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
    
    func saveCity(city: String) async {
        do {
            let response = try await network.saveCity(city: city)
            let domainModel = mapFavouriteCity(serviceModel: response)
            print("✅ Saved city:", response.city)
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }

}
