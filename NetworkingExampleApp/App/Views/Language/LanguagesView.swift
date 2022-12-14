import SwiftUI

struct LanguagesView: View {
  @StateObject var viewModel: LanguagesViewModel

  var body: some View {
    VStack {
      List {
        ForEach(Array(viewModel.languages.enumerated()), id: \.offset) { index, language in
          NavigationLink(destination: LanguageDetailView(viewModel: viewModel.generateViewModel(language: language, showRingPicker: true))) {
            LanguageCell(languageName: language.name)
          }
        }
        .onDelete() { indexSet in
          for index in indexSet {
            viewModel.deleteLanguage(id: viewModel.languages[index].id)
          }
        }
      }
      .searchable(text: $viewModel.searchText, prompt: "Language")
    }
    .onAppear() {
      viewModel.getLanguages()
    }
    .listStyle(.inset)
    .navigationTitle("Languages")
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarItems(trailing: Button(action: {}) {
      addButton
    })
  }

  private var addButton: some View {
    NavigationLink(destination: LanguageDetailView(viewModel: viewModel.generateViewModel(showRingPicker: true))) {
      Image(systemName: "plus")
    }
  }
}

struct LanguagesView_Previews: PreviewProvider {
    static var previews: some View {
      LanguagesView(viewModel: LanguagesViewModel())
    }
}
