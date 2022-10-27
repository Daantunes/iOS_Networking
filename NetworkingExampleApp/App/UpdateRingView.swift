import SwiftUI

struct UpdateRingView: View {
  @Environment(\.presentationMode) var presentationMode
  @Environment(\.dismiss) private var dismiss
  @State private var buttonClicked = false

  let ring: Ring
  @State var ringName: String

  init(ring: Ring) {
    self.ring = ring
    _ringName = State(initialValue: ring.name)
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text("Ring Name")
        .font(.callout)
        .bold()
      TextField("Enter ring name...", text: $ringName)
        .textFieldStyle(.roundedBorder)
      Spacer()
    }
    .padding()
    .navigationBarItems(trailing: Button(action: {}) {
      doneButton
    })
  }

  private var doneButton: some View {
    Button("Done") {
      buttonClicked = true
      RequestManager().sendRequest(router: .updateRing(id: ring.id, name: ringName), responseModel: Ring.self) { completion in
        buttonClicked = false
        switch completion {
          case .success:
            DispatchQueue.main.async {
              dismiss()
            }
          case .failure(let error):
            print(error)
        }
      }
    }
    .disabled(buttonClicked)
  }
}

struct UpdateRingView_Previews: PreviewProvider {
  static var previews: some View {
    UpdateRingView(ring: Ring(id: "4", name: "Dummy", languages: nil))
  }
}
