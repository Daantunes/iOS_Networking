import SwiftUI

struct LoginView: View {
  @State var username: String = ""
  @State var password: String = ""
  @State var errorMessage: String = ""
  @EnvironmentObject var sessionStatus: SessionStatus

    var body: some View {
      VStack(alignment: .leading) {
        Text("Username")
          .font(.callout)
          .bold()
        TextField("Enter username...", text: $username)
          .disableAutocorrection(true)
          .autocapitalization(.none)
          .textFieldStyle(.roundedBorder)

        Text("Password")
          .font(.callout)
          .bold()
        SecureField("Enter password...", text: $password)
          .textFieldStyle(.roundedBorder)

        Button("Login") {
          Session.shared.signIn(username: username, password: password) { error in
            if let error {
              errorMessage = "Error: \(error)"
            } else {
              DispatchQueue.main.async {
                sessionStatus.isLoggedIn = true
              }
            }
          }
        }

        Text(errorMessage)
          .multilineTextAlignment(.center)
          .foregroundColor(.red)
        Spacer()
      }
      .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
