import Foundation

struct Language: Codable, Identifiable, Hashable {
  let id: UUID
  let name: String
}


extension Language: Equatable {
  static func == (lhs: Language, rhs: Language) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
  }
}
