import SwiftUI

@main
struct PawsomeApp: App {
  @WKExtensionDelegateAdaptor(ExtensionDelegate.self)
  private var extensionDelegate

  private let local = LocalNotifications()

  @SceneBuilder var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
      }
    }

    WKNotificationScene(
      controller: NotificationController.self,
      category: LocalNotifications.categoryIdentifier
    )

    WKNotificationScene(
      controller: RemoteNotificationController.self,
      category: RemoteNotificationController.categoryIdentifier
    )
  }
}
