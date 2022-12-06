import Foundation

enum RingPickerState {
  case visible(ringID: UUID)
  case hidden
}

extension RingPickerState {
  var ringID: UUID {
    get {
      switch self {
        case .visible(let ringID):
          return ringID
        case .hidden:
          return UUID()
      }
    }
    set {
      switch self {
        case .visible:
          self = .visible(ringID: newValue)
        case .hidden:
          self = .hidden
      }
    }
  }
}
