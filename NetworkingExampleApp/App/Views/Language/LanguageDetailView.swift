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
      ringPickerView
        .padding(.vertical)
        .disabled(viewModel.state == .read)
      Spacer()
    }
    .onAppear {
      if viewModel.showRingPicker {
        viewModel.getRings()
        viewModel.getRingID()
      }
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

  private var ringPickerView: some View {
    switch viewModel.ringPickerState {
      case .visible:
        return AnyView(RingPicker(selectedRing: $viewModel.ringPickerState.ringID, rings: viewModel.rings))
      case .hidden:
        return AnyView(Text(""))
    }
  }

  private var addButton: some View {
    Button("Add") {
      viewModel.addLanguage()
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
    LanguageDetailView(viewModel: LanguageDetailViewModel(language: nil))
  }
}
