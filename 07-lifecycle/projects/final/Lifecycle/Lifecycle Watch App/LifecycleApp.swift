import SwiftUI

@main
struct Lifecycle_Watch_AppApp: App {
  @Environment(\.scenePhase) private var scenePhase

  @WKExtensionDelegateAdaptor(ExtensionDelegate.self)
  private var extensionDelegate

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .onChange(of: scenePhase) {
      print("onChange: \($0)")
    }
  }
}
