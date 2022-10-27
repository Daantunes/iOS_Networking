import SwiftUI

struct CreateRingView: View {
  @Environment(\.presentationMode) var presentationMode
  @Environment(\.dismiss) private var dismiss
  
  @State var ringName: String = ""

  var body: some View {
    NavigationView {
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
  }

  private var addButton: some View {
    Button("Add") {
      RequestManager().sendRequest(router: .createRing(name: ringName), responseModel: Ring.self) { completion in
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
  }
}

struct CreateRingView_Previews: PreviewProvider {
  static var previews: some View {
    CreateRingView()
  }
}
