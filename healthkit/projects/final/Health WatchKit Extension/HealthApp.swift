import SwiftUI

@main
struct HealthApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
      }
      .task {
        _ = HealthStore.shared
      }
    }
  }
}
