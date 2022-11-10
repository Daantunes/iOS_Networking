import SwiftUI

struct LanguageDetailView: View {
  @Environment(\.presentationMode) var presentationMode
  @Environment(\.dismiss) private var dismiss
  @State private var buttonClicked = false

  @State var languageName: String = ""
  var ring: Ring

  var body: some View {
    VStack(alignment: .leading) {
      Text("Language Name")
        .font(.callout)
        .bold()
      TextField("Enter language name...", text: $languageName)
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
      RequestManager().sendRequest(router: .createLanguage(name: languageName, ringID: ring.id), responseModel: Language.self) { completion in
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

struct LanguageDetailView_Previews: PreviewProvider {
  static var previews: some View {
    LanguageDetailView(ring: Ring(id: UUID(uuidString: "DD7DCC97-C61D-4AB9-B80E-7C87CFE66831")!, name: "Dummy", languages: []))
  }
}
