import SwiftUI

@main
struct FaceSharingApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(Session.shared)
    }
  }
}
