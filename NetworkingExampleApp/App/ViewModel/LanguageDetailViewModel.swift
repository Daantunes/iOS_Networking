import Foundation

class LanguageDetailViewModel: ObservableObject {
  @Published var state: DetailViewState = .read
  @Published var dismiss: Bool = false

  // MARK: - Properties -

  let language: Language?
  var languageName: String
  var onSave: (_ language: Language) -> Void = { _ in }
  var onAdd: (_ name: String) -> Void = { _ in }

  init(language: Language?) {
    self.language = language
    self.languageName = language == nil ? "" : language!.name
    self.state = language == nil ? .create : .read
  }

  func saveLanguage() {
    guard let language else { return }
    onSave(Language(id: language.id, name: languageName))
    dismiss = true
  }

  func addLanguage() {
    onAdd(languageName)
    dismiss = true
  }
}
