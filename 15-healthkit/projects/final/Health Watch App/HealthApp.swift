import SwiftUI

@main
struct Health_Watch_AppApp: App {
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
