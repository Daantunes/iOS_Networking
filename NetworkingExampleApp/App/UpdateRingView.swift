import SwiftUI

struct UpdateRingView: View {
  @Environment(\.presentationMode) var presentationMode
  @Environment(\.dismiss) private var dismiss
  @State private var buttonClicked = false

  let ring: Ring
  @State var ringName: String
  @State var languages: [Language] = []

  init(ring: Ring) {
    self.ring = ring
    _ringName = State(initialValue: ring.name)
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text("Ring Name:")
        .font(.callout)
        .bold()
      TextField("Enter ring name...", text: $ringName)
        .textFieldStyle(.roundedBorder)
      Spacer(minLength: 50)
      if !languages.isEmpty {
        Text("Languages:")
          .font(.callout)
          .bold()
      }
      List {
        ForEach(languages) { language in
          Text(language.name)
        }
        .onDelete() { indexSet in
          for index in indexSet {
            deleteLanguage(id: languages[index].id)
            languages.remove(at: index)
          }
        }
      }
      .listStyle(.inset)
      NavigationLink("Add Language") { LanguageDetailView(ring: ring) }
      Spacer()
    }
    .padding()
    .onAppear {
      getRingLanguages()
    }
    .navigationBarItems(trailing: Button(action: {}) {
      doneButton
    })
  }

  private func deleteLanguage(id: UUID) {
    RequestManager().sendRequest(router: .deleteLanguage(id: id)) { completion in
      switch completion {
        case .success:
          getRingLanguages()
        case .failure(let failure):
          print(failure)
      }
    }
  }

  private func getRingLanguages() {
    RequestManager()
      .sendRequest(router: .getRingLanguages(id: ring.id), responseModel: [Language].self) { completion in
        switch completion {
          case .success(let languages):
            self.languages = languages
          case .failure(let error):
            print(error)
        }
      }
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
    UpdateRingView(ring: Ring(id: UUID(uuidString: "DD7DCC97-C61D-4AB9-B80E-7C87CFE66831")!, name: "Dummy", languages: []))
  }
}
