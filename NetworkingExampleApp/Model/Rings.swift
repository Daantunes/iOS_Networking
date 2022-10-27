import Foundation

struct Ring: Codable {
  let id: String
  let name: String
  let languages: [Language]?
}

struct Language: Codable {
  let id: String
  let name: String
  let ringId: String
}
