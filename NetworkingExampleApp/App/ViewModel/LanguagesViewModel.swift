import Foundation

class LanguagesViewModel: ObservableObject {
  @Published private(set) var languages: [Language] = []
  @Published var dismiss: Bool = false

  var languageDetailViewModel: LanguageDetailViewModel?

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
}
