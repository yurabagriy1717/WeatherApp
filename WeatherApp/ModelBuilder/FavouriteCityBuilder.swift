//
//  FavouriteCityBuilder.swift
//

protocol FavouriteCityBuildable {
    func buildFavouriteCity(response: FavouriteCityResponse) -> FavouriteCityModel
}

final class FavouriteCityBuilder: FavouriteCityBuildable {
    static let shared = FavouriteCityBuilder()
    
    func buildFavouriteCity(response: FavouriteCityResponse) -> FavouriteCityModel {
        FavouriteCityModel(id: response.id,
                           city: response.city)
    }
}
