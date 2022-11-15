import SwiftUI

@main
struct NetworkingExampleApp: App {
  @StateObject var sessionStatus = SessionStatus.shared

  var body: some Scene {
    WindowGroup {
      NavigationView {
        if sessionStatus.isLoggedIn {
          RingsView(viewModel: RingsViewModel())
        } else {
          LoginView()
        }
      }
      .navigationViewStyle(.stack)
      .environmentObject(sessionStatus)
    }
  }
}
