import Foundation
struct CharacterData: Codable {
    let info: Info?
    let results: [CharacterItem]?
}

// MARK: - Info
struct Info: Codable {
    let count, pages: Int?
    let next: String?
    let prev: String?
}

// MARK: - Result
struct CharacterItem: Codable {
    let id: Int?
    let name: String?
    let status: Status?
    let species: Species?
    let type: String?
    let origin: Origin?
    let gender: Gender?
    let image: String?
    let url: String?
}

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
    case unknown = "unknown"
    case genderless = "Genderless"
}

struct Origin: Codable {
    let name: String
    let url: String
}

enum Species: String, Codable {
    case alien = "Alien"
    case human = "Human"
    case mythologicalCreature = "Mythological Creature"
    case disease = "Disease"
    case animal = "Animal"
    case cronenberg = "Cronenberg"
    case humanoid = "Humanoid"
    case unknown = "unknown"
    case poopybutthole = "Poopybutthole"
    case robot = "Robot"
}

enum Status: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
