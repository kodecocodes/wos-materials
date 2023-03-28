import WatchKit
import ClockKit

final class ExtensionDelegate: NSObject, WKExtensionDelegate {
  public static func updateActiveComplications() {
    let server = CLKComplicationServer.sharedInstance()
    server.activeComplications?.forEach {
      server.reloadTimeline(for: $0)
    }
  }
}
