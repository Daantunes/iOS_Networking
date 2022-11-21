import SwiftUI

struct RingDetailView: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject var viewModel: RingDetailViewModel

  var body: some View {
    VStack(alignment: .leading) {
      Text("Ring Name")
        .font(.callout)
        .bold()
      TextField("Enter ring name...", text: $viewModel.ringName)
        .textFieldStyle(.roundedBorder)
        .disabled(viewModel.state == .read)
      Spacer(minLength: 50)
      RingLanguagesView(viewModel: viewModel)
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
          doneButton
        case .read:
          editButton
      }
    })
  }

  private var addButton: some View {
    Button("Add") {
      viewModel.createRing()
    }
  }

  private var editButton: some View {
    Button("Edit") {
      viewModel.state = .edit
    }
  }

  private var doneButton: some View {
    Button("Done") {
      viewModel.updateRing()
    }
  }
}

struct RingDetailView_Previews: PreviewProvider {
  static var previews: some View {
    RingDetailView(viewModel: RingDetailViewModel(ring: MockRing().ring))
  }
}
