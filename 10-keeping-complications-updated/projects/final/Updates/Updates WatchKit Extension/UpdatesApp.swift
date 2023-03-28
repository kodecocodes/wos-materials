import SwiftUI

@main
struct UpdatesApp: App {
  @WKExtensionDelegateAdaptor(ExtensionDelegate.self)
  // swiftlint:disable:next weak_delegate
  private var extensionDelegate

  private let push = PushNotificationProvider()
  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
      }
    }
  }
}
