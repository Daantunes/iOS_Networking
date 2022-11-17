import Foundation

enum DetailViewState {
  case create
  case edit
  case read
}

class RingDetailViewModel: ObservableObject {
  @Published var state: DetailViewState
  @Published var dismiss: Bool = false
  @Published var tempLanguages: [Language]

  var languageDetailViewModel: LanguageDetailViewModel?

  let ring: Ring?
  var ringName: String


  init(ring: Ring?) {
    self.ring = ring
    self.ringName = ring == nil ? "" : ring!.name
    self.tempLanguages = ring?.languages ?? []
    self.state = ring == nil ? .create : .read
  }

  func generateLanguageViewModel(language: Language? = nil) -> LanguageDetailViewModel {
    languageDetailViewModel = LanguageDetailViewModel(state: state, language: language)

    languageDetailViewModel!.onSave = { [weak self] language in
      guard let self else { return }

      if let index = self.tempLanguages.firstIndex(where: { language.id == $0.id }) {
        self.tempLanguages[index] = language
      } else {
        self.tempLanguages.append(language)
      }
    }

    return languageDetailViewModel!
  }

  func createRing() {
    APIService.shared.createRing(name: ringName) { completion in
      switch completion {
        case .success:
          DispatchQueue.main.async {
            self.dismiss = true
          }
        case .failure(let error):
          print(error)
      }
    }
  }

  func updateRing() {
    guard let ring else { return }

    if ringName != ring.name {
      updateRingName()
    }

    if tempLanguages != ring.languages {
      updateLanguagesOfRing()
    }
  }

  private func updateRingName() {
    guard let ring else { return }

    APIService.shared.updateRing(id: ring.id, name: ringName) { completion in
      switch completion {
        case .success:
          DispatchQueue.main.async {
            if !self.dismiss { self.dismiss = true }
          }
        case .failure(let error):
          print(error)
      }
    }
  }

  private func updateLanguagesOfRing() {
    guard let ring else { return }
    
    APIService.shared.updateRingLanguages(ringID: ring.id, languages: tempLanguages) { completion in
      switch completion {
        case .success:
          DispatchQueue.main.async {
            if !self.dismiss { self.dismiss = true }
          }
        case .failure(let failure):
          print(failure)
      }
    }
  }
}
