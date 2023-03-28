import SwiftUI
import WatchConnectivity

final class Session: NSObject, ObservableObject {
  static let shared = Session()

  override private init() {
    super.init()

    guard WCSession.isSupported() else {
      return
    }

    WCSession.default.delegate = self
    WCSession.default.activate()
  }
}

extension Session: WCSessionDelegate {
  func sessionDidBecomeInactive(_ session: WCSession) {
  }

  func sessionDidDeactivate(_ session: WCSession) {
    WCSession.default.activate()
  }

  func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
  }
}
