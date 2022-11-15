import Foundation

class LanguageDetailViewModel: ObservableObject {
  @Published var state: DetailViewState = .read
  @Published var dismiss: Bool = false

  // MARK: - Properties -

  let language: Language?
  var languageName: String
  var onSave: (_ language: Language) -> Void = { _ in }

  init(state: DetailViewState, language: Language?) {
    self.language = language
    self.languageName = language == nil ? "" : language!.name
    self.state = language == nil ? .create : .read
  }

  func saveLanguage() {
    if let language {
      onSave(Language(id: language.id, name: languageName))
    } else {
      onSave(Language(id: UUID(), name: languageName))
    }
    self.dismiss = true
  }
}
