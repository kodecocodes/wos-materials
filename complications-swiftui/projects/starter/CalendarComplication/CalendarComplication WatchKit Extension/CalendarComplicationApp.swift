import SwiftUI

@main
struct CalendarComplicationApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
        EventView()
      }
    }
  }
}
