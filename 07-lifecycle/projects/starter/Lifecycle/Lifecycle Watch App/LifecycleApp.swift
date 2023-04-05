import SwiftUI

@main
struct LifecycleApp: App {
  @Environment(\.scenePhase) private var scenePhase
  @WKExtensionDelegateAdaptor(ExtensionDelegate.self)
  private var extensionDelegate

  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
      }
    }
    .onChange(of: scenePhase) {
      print("onChange: \($0)")
    }
  }
}
