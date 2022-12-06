import Foundation

struct Ring: Codable, Identifiable, Hashable {
  let id: UUID
  let name: String
  let languages: [Language]?
}
