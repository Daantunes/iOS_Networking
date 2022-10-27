import SwiftUI

struct CreateRingView: View {
  @Environment(\.presentationMode) var presentationMode
  @Environment(\.dismiss) private var dismiss
  @State private var buttonClicked = false
  
  @State var ringName: String = ""

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
      addButton
    })
  }

  private var addButton: some View {
    Button("Add") {
      buttonClicked = true
      RequestManager().sendRequest(router: .createRing(name: ringName), responseModel: Ring.self) { completion in
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

struct CreateRingView_Previews: PreviewProvider {
  static var previews: some View {
    CreateRingView()
  }
}
