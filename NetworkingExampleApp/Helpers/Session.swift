import Foundation

@MainActor
class SessionStatus: ObservableObject {
  static let shared = SessionStatus()
  
  @Published var isLoggedIn = Session.shared.accessToken != nil
}

final class Session {
  static let shared = Session()
  private(set) var accessToken: String?

  init(isLoggedIn: Bool = false, accessToken: String? = nil) {
    let auth = KeychainHelper.shared.read(service: "tokens", account: "user", type: Auth.self)
    self.accessToken = auth?.accessToken
  }

  func signIn(username: String, password: String, completion: @escaping (RequestError?)-> Void) {
    RequestManager()
      .sendRequest(
        router: .login(username: username, password: password),
        responseModel: Token.self
      ) { [weak self] result in
        switch result {
          case .success(let token):
            let auth = Auth(accessToken: token.value)
            KeychainHelper.shared.save(auth, service: "tokens", account: "user")
            self?.accessToken = token.value
            completion(nil)
          case .failure(let failure):
            completion(failure)
        }
      }
  }

  func signOut()  {
    KeychainHelper.shared.delete(service: "tokens", account: "user")
    self.accessToken = nil
  }
}
