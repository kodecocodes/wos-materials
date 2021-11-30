import SwiftUI

@main
struct CalendarComplicationApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationView {
        EventComplicationView(event: nil)
      }
    }
  }
}
