import Foundation

@MainActor
class SessionStatus: ObservableObject {
  static let shared = SessionStatus()
  
  @Published var isLoggedOut = {
    Session.shared.accessToken == nil
  }()
}

final class Session {
  static let shared = Session()
  private(set) var accessToken: String? {
    didSet {
      DispatchQueue.main.async { [weak self] in
        SessionStatus.shared.isLoggedOut = self?.accessToken == nil
      }
    }
  }

  init(isLoggedIn: Bool = false, accessToken: String? = nil) {
    let auth = KeychainHelper.shared.read(service: "tokens", account: "user", type: Auth.self)
    self.accessToken = auth?.accessToken
  }

  func signIn(username: String, password: String, completion: @escaping (RequestError?)-> Void) {
    APIService.shared.loginUser(username: username, password: password) { [weak self] result in
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
