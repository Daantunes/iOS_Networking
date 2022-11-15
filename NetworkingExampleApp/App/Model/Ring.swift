import Foundation

struct Ring: Codable, Identifiable {
  let id: UUID
  let name: String
  let languages: [Language]?
}
