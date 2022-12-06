import Foundation

class LanguageDetailViewModel: ObservableObject {

  // MARK: - Published Properties -

  @Published var state: DetailViewState = .read
  @Published var dismiss: Bool = false
  @Published var ringPickerState: RingPickerState = .hidden

  // MARK: - Properties -

  let showRingPicker: Bool
  let language: Language?

  var languageName: String
  var onSave: (_ language: Language, _ ringID: UUID) -> Void = { _, _ in }
  var onAdd: (_ name: String, _ ringID: UUID) -> Void = { _, _ in }
  
  private(set) var rings = [Ring]()

  // MARK: - Lifecycle -

  init(language: Language?, showRingPicker: Bool = false) {
    self.language = language
    self.languageName = language == nil ? "" : language!.name
    self.state = language == nil ? .create : .read
    self.showRingPicker = showRingPicker
  }

  // MARK: - Public Methods -

  func saveLanguage() {
    guard let language else { return }
    onSave(Language(id: language.id, name: languageName), ringPickerState.ringID)
    dismiss = true
  }

  func addLanguage() {
    onAdd(languageName, ringPickerState.ringID)
    dismiss = true
  }

  func getRings() {
    APIService.shared.getAllRings { [weak self] completion in
      guard let self else { return }
      
      switch completion {
        case .success(let rings):
          DispatchQueue.main.async {
            self.rings = rings

            switch self.ringPickerState {
              case .hidden:
                if let ring = rings.first {
                  self.ringPickerState = .visible(ringID: ring.id)
                }
              default:
                break
            }
          }
        case .failure(let failure):
          print(failure)
      }
    }
  }

  func getRingID() {
    guard let language else { return }

    APIService.shared.getLanguageRing(id: language.id) { completion in
      switch completion {
        case .success(let ring):
          DispatchQueue.main.async {
            self.ringPickerState = .visible(ringID: ring.id)
          }
        case .failure(let error):
          print(error)
      }
    }
  }
}
