// KILDER:
// - https://developer.apple.com/documentation/foundation
// - https://medium.com/@nimjea/json-parsing-in-swift-2498099b78f

import Foundation

class Movies: Codable {
    let count: Int
    let results: [MoviesResult]
    
    init(count: Int, results: [MoviesResult]) {
        self.count = count
        self.results = results
    }
}

class MoviesResult: Codable {
    let title: String?
    let episode_id: Int?
    let opening_crawl, director, producer, release_date: String?
    let characters, planets, starships, vehicles: [String]?
    let species: [String]?
    let created, edited: String?
    let url: String?
    
    init(title: String, episode_id: Int, opening_crawl: String, director: String, producer: String, release_date: String, characters: [String], planets: [String], starships: [String], vehicles: [String], species: [String], created: String, edited: String, url: String) {
        self.title = title
        self.episode_id = episode_id
        self.opening_crawl = opening_crawl
        self.director = director
        self.producer = producer
        self.release_date = release_date
        self.characters = characters
        self.planets = planets
        self.starships = starships
        self.vehicles = vehicles
        self.species = species
        self.created = created
        self.edited = edited
        self.url = url
    }
}
