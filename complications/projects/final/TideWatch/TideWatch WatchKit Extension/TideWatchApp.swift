import SwiftUI

@main
struct TideWatchApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
  }
}
