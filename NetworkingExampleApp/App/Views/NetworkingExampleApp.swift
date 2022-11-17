import SwiftUI

@main
struct NetworkingExampleApp: App {
  @StateObject var sessionStatus = SessionStatus.shared

  var body: some Scene {
    WindowGroup {
      NavigationView {
          RingsView(viewModel: RingsViewModel())
          .sheet(isPresented: $sessionStatus.isLoggedOut) {
            LoginView()
          }
      }
      .navigationViewStyle(.stack)
      .environmentObject(sessionStatus)
    }
  }
}
