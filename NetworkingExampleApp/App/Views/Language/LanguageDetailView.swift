import SwiftUI

struct LanguageDetailView: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject var viewModel: LanguageDetailViewModel

  var body: some View {
    VStack(alignment: .leading) {
      Text("Language Name")
        .font(.callout)
        .bold()
      TextField("Enter language name...", text: $viewModel.languageName)
        .textFieldStyle(.roundedBorder)
        .disabled(viewModel.state == .read)
      Spacer()
    }
    .padding()
    .onChange(of: viewModel.dismiss) {
      if $0 { dismiss() }
    }
    .navigationBarItems(trailing: Button(action: {}) {
      switch viewModel.state {
        case .create:
          addButton
        case .edit:
          saveButton
        case .read:
          editButton
      }
    })
  }

  private var addButton: some View {
    Button("Add") {
      viewModel.saveLanguage()
    }
  }


  private var editButton: some View {
    Button("Edit") {
      viewModel.state = .edit
    }
  }

  private var saveButton: some View {
    Button("Save") {
      viewModel.saveLanguage()
    }
  }


}

struct LanguageDetailView_Previews: PreviewProvider {
  static var previews: some View {
    LanguageDetailView(viewModel: LanguageDetailViewModel(state: .read, language: nil))
  }
}
