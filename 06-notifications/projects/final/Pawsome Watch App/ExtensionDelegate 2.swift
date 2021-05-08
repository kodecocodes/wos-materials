import WatchKit
import UserNotifications

final class ExtensionDelegate: NSObject, WKExtensionDelegate {
  func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {
    print(deviceToken.reduce("") { $0 + String(format: "%02x", $1) })
  }

  func applicationDidFinishLaunching() {
    Task {
      do {
        let success = try await UNUserNotificationCenter
          .current()
          .requestAuthorization(options: [.badge, .sound, .alert])

        guard success else { return }

        await MainActor.run {
          WKExtension.shared().registerForRemoteNotifications()
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
