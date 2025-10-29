//
//  DataService.swift
//

import Foundation

protocol DataService {
    func saveLastCity(_ city: String)
    func loadLastCity() -> String?
    func saveFavouriteCities(_ cities: [String])
    func loadFavouriteCities() -> [String]
}

final class DefaultDataService: DataService {
    static let shared = DefaultDataService()
    private let defaults = UserDefaults.standard
    private init() {}
    
    func saveLastCity(_ city: String) {
        defaults.set(city, forKey: "lastCity")
    }
    
    func loadLastCity() -> String? {
        defaults.string(forKey: "lastCity")
    }
    
    func saveFavouriteCities(_ cities: [String]) {
        defaults.set(cities, forKey: "favouriteCities")
    }
    
    func loadFavouriteCities() -> [String] {
        defaults.array(forKey: "favouriteCities") as? [String] ?? []
    }
    
}
