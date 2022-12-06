import Foundation

class LanguagesViewModel: ObservableObject {

  // MARK: - Published Properties -

  @Published private(set) var languages: [Language] = []
  @Published var dismiss: Bool = false

  // MARK: - Properties -

  var searchText = "" {
    didSet {
      searchLanguage(query: searchText)
    }
  }

  var languageDetailViewModel: LanguageDetailViewModel?
  private var debounce_timer:Timer?

  // MARK: - Public Methods -

  func generateViewModel(language: Language? = nil, showRingPicker: Bool = false) -> LanguageDetailViewModel {
    languageDetailViewModel = LanguageDetailViewModel(language: language, showRingPicker: showRingPicker)

    languageDetailViewModel!.onSave = { language, ringID in
      APIService.shared.updateLanguage(id: language.id, name: language.name, ringID: ringID) { completion in
        handleCompletion(completion: completion)
      }
    }

    languageDetailViewModel!.onAdd = { name, ringID in
      APIService.shared.createLanguage(name: name, ringID: ringID) { completion in
        handleCompletion(completion: completion)
      }
    }

    func handleCompletion<T>(completion: Result<T, RequestError>) {
      switch completion {
        case .success:
          DispatchQueue.main.async {
            if !self.dismiss { self.dismiss = true }
          }
        case .failure(let failure):
          print(failure)
      }
    }

    return languageDetailViewModel!
  }

  func getLanguages() {
    APIService.shared.getAllLanguages { completion in
      switch completion {
        case .success(let languages):
          DispatchQueue.main.async {
            self.languages = languages
          }
        case .failure(let failure):
          print(failure)
      }
    }
  }

  func deleteLanguage(id: UUID) {
    APIService.shared.deleteLanguage(id: id) { completion in
      switch completion {
        case .success:
          break
        case .failure(let failure):
          print(failure)
      }
    }
  }

  // MARK: - Private Methods -

  private func searchLanguage(query: String) {
    debounce_timer?.invalidate()
    debounce_timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { _ in
      APIService.shared.searchLanguages(query: query) { [weak self] completion in
        guard let self else { return }

        DispatchQueue.main.async {
          switch completion {
            case .success(let languages):
              self.languages = languages
            case .failure(let error):
              print(error)
          }
        }
      }
    }
  }
}
