import Foundation

class RingDetailViewModel: ObservableObject {

  // MARK: - Published Properties -

  @Published var state: DetailViewState
  @Published var dismiss: Bool = false
  @Published var tempLanguages: [Language]

  // MARK: - Properties -

  var languageDetailViewModel: LanguageDetailViewModel?

  let ring: Ring?
  var ringName: String

  // MARK: - Lifecycle -

  init(ring: Ring?) {
    self.ring = ring
    self.ringName = ring == nil ? "" : ring!.name
    self.tempLanguages = ring?.languages ?? []
    self.state = ring == nil ? .create : .read
  }

  // MARK: - Public Methods -

  func generateLanguageViewModel(language: Language? = nil) -> LanguageDetailViewModel {
    languageDetailViewModel = LanguageDetailViewModel(language: language)

    languageDetailViewModel!.onSave = { [weak self] language, _ in
      guard let self else { return }

      if let index = self.tempLanguages.firstIndex(where: { language.id == $0.id }) {
        self.tempLanguages[index] = language
      }
    }

    languageDetailViewModel!.onAdd = { [weak self] name, _ in
      guard let self else { return }
      
      self.tempLanguages.append(Language(id: UUID(), name: name))
    }

    return languageDetailViewModel!
  }

  func createRing() {
    if tempLanguages.isEmpty {
      APIService.shared.createRing(name: ringName) { completion in
        self.handleCompletion(completion: completion)
      }
    } else {
      APIService.shared.createRingWithLanguages(name: ringName, languages: tempLanguages) { completion in
        self.handleCompletion(completion: completion)
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

  // MARK: - Private Methods -

  private func updateRingName() {
    guard let ring else { return }

    APIService.shared.updateRing(id: ring.id, name: ringName) { completion in
      self.handleCompletion(completion: completion)
    }
  }

  private func updateLanguagesOfRing() {
    guard let ring else { return }
    
    APIService.shared.updateRingLanguages(ringID: ring.id, languages: tempLanguages) { completion in
      self.handleCompletion(completion: completion)
    }
  }

  private func handleCompletion<T>(completion: Result<T, RequestError>) {
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
