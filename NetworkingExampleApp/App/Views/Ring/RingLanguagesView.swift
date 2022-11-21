import SwiftUI

struct RingLanguagesView: View {
  @StateObject var viewModel: RingDetailViewModel
  @State var titleLabel: String = ""

  var body: some View {
    Text(titleLabel)
      .font(.callout)
      .bold()

    VStack() {
      List {
        ForEach(viewModel.tempLanguages) { language in
          NavigationLink(
            destination: LanguageDetailView(viewModel: viewModel.generateLanguageViewModel(language: language))
          ) {
            Text(language.name)
          }
        }
        .onDelete() { indexSet in
          for index in indexSet {
            viewModel.tempLanguages.remove(at: index)
          }
        }
        .deleteDisabled(viewModel.state == .read)
        .disabled(viewModel.state == .read)
      }
      .listStyle(.inset)

      if viewModel.state == .edit {
        Button(action: {}) {
          NavigationLink(destination: LanguageDetailView(viewModel: viewModel.generateLanguageViewModel())) {
            Text("Add Language")
          }
        }
      }

      Spacer()
    }
    .onAppear() {
      setTitleName()
    }
    .onChange(of: viewModel.tempLanguages) { _ in
      setTitleName()
    }
  }

  func setTitleName() {
    if viewModel.tempLanguages.isEmpty {
      titleLabel = ""
    } else {
      titleLabel = "Languages:"
    }
  }
}

struct RingLanguagesView_Previews: PreviewProvider {
  static var previews: some View {
    RingLanguagesView(viewModel: RingDetailViewModel(ring: MockRing().ring))
  }
}
