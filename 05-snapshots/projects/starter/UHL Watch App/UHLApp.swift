import SwiftUI

@main
struct UHL_Watch_AppApp: App {
  // swiftlint:disable weak_delegate
  @WKExtensionDelegateAdaptor(ExtensionDelegate.self)
  private var extensionDelegate
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(Season.shared)
    }
  }
}
