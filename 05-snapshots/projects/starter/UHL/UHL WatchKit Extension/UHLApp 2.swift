import SwiftUI

@main
struct UHLApp: App {
  // swiftlint:disable weak_delegate
  @WKExtensionDelegateAdaptor(ExtensionDelegate.self)
  private var extensionDelegate
  
  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
      }
      .environmentObject(Season.shared)
    }
  }
}
