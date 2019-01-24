// KILDER:
// - https://developer.apple.com/documentation/foundation
// - https://medium.com/@nimjea/json-parsing-in-swift-2498099b78f


import Foundation

class People: Codable {
    let count: Int
    let next: String
    let results: [PeopleResult]
    
    init(count: Int, next: String, results: [PeopleResult]) {
        self.count = count
        self.next = next
        self.results = results
    }
}
class PeopleResult: Codable {
    let name, height, mass, hairColor: String?
    let skinColor, eyeColor, birthYear: String?
    let gender: String?
    let homeworld: String?
    let films, species, vehicles, starships: [String]?
    let created, edited: String?
    let url: String?
    
    init(name: String, height: String, mass: String, hairColor: String, skinColor: String, eyeColor: String, birthYear: String, gender: String, homeworld: String, films: [String], species: [String], vehicles: [String], starships: [String], created: String, edited: String, url: String) {
        self.name = name
        self.height = height
        self.mass = mass
        self.hairColor = hairColor
        self.skinColor = skinColor
        self.eyeColor = eyeColor
        self.birthYear = birthYear
        self.gender = gender
        self.homeworld = homeworld
        self.films = films
        self.species = species
        self.vehicles = vehicles
        self.starships = starships
        self.created = created
        self.edited = edited
        self.url = url
    }
}
