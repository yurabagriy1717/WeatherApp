//
//  FavouriteCityRequest.swift
//

import Foundation

struct FavouriteCityRequest: Codable {
    let city: String
}

struct FavouriteCityResponse: Codable {
    let id: Int
    let city: String
}


