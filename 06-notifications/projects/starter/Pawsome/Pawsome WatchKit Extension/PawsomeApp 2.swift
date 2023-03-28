import SwiftUI

@main
struct PawsomeApp: App {
  private let local = LocalNotifications()

  @SceneBuilder var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
      }
    }

    WKNotificationScene(
      controller: NotificationController.self,
      category: "myCategory"
    )
  }
}
