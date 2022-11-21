import SwiftUI

@main
struct NetworkingExampleApp: App {
  @StateObject var sessionStatus = SessionStatus.shared

  var body: some Scene {
    WindowGroup {
      TabView {
        NavigationView {
          RingsView(viewModel: RingsViewModel())
            .sheet(isPresented: $sessionStatus.isLoggedOut) {
              LoginView()
            }
        }
        .navigationViewStyle(.stack)
        .tabItem {
          Label("Rings", systemImage: "circle.circle.fill")
        }

        NavigationView {
          LanguagesView(viewModel: LanguagesViewModel())
            .sheet(isPresented: $sessionStatus.isLoggedOut) {
              LoginView()
            }
        }
        .navigationViewStyle(.stack)
        .tabItem {
          Label("Languages", systemImage: "list.bullet.circle.fill")
        }
      }
      .environmentObject(sessionStatus)
    }
  }
}
