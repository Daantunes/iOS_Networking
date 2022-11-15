import Foundation

struct MockRing {
  let ring = Ring(
    id: UUID(),
    name: "Mock Ring",
    languages: [
      Language(
        id: UUID(),
        name: "Mock Language"
      )
    ]
  )
}
