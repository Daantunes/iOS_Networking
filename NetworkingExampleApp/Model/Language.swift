import Foundation

struct Language: Codable, Identifiable {
  let id: UUID
  let name: String
  let ringId: UUID
}

