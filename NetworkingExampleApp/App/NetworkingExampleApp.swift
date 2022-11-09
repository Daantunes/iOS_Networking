import SwiftUI

@main
struct NetworkingExampleApp: App {
  @StateObject var sessionStatus = SessionStatus.shared

  init() {
//    Session.shared.signOut()
  }

  var body: some Scene {
    WindowGroup {
      NavigationView {
        if sessionStatus.isLoggedIn {
          RingsView()
        } else {
          LoginView()
        }
      }
      .navigationViewStyle(.stack)
      .environmentObject(sessionStatus)
    }
  }
}
