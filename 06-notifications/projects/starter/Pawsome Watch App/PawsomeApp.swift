import SwiftUI
import WatchKit

@main
struct Pawsome_Watch_AppApp: App {
  private let local = LocalNotifications()

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
