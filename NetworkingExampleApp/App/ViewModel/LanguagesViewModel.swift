import Foundation

class LanguagesViewModel: ObservableObject {
  @Published private(set) var languages: [Language] = []
  @Published var dismiss: Bool = false

  var searchText = "" {
    didSet {
      searchLanguage(query: searchText)
    }
  }

  var languageDetailViewModel: LanguageDetailViewModel?
  private var debounce_timer:Timer?

  func generateViewModel(language: Language? = nil) -> LanguageDetailViewModel {
    languageDetailViewModel = LanguageDetailViewModel(language: language)

    languageDetailViewModel!.onSave = { language in
      APIService.shared.updateLanguage(id: language.id, name: language.name) { completion in
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

    languageDetailViewModel!.onAdd = { name in
      
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
