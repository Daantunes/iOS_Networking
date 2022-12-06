import Foundation

class RingsViewModel: ObservableObject {

  // MARK: - Published Properties -

  @Published private(set) var rings: [Ring] = []

  // MARK: - Public Methods -
  
  func generateViewModel(ring: Ring? = nil) -> RingDetailViewModel {
    return RingDetailViewModel(ring: ring)
  }

  func getRings() {
    APIService.shared.getAllRings { completion in
      switch completion {
        case .success(let rings):
          DispatchQueue.main.async {
            self.rings = rings
          }
        case .failure(let failure):
          print(failure)
      }
    }
  }

  func deleteRing(id: UUID) {
    APIService.shared.deleteRing(id: id) { completion in
      switch completion {
        case .success:
          break
        case .failure(let failure):
          print(failure)
      }
    }
  }
}
