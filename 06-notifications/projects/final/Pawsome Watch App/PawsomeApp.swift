import SwiftUI
import WatchKit

@main
struct Pawsome_Watch_AppApp: App {
  @WKExtensionDelegateAdaptor(ExtensionDelegate.self)
  private var extensionDelegate
  
  private let local = LocalNotifications()

  var body: some Scene {
    WindowGroup {
      ContentView()
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
