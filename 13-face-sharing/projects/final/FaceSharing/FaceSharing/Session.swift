import SwiftUI
import WatchConnectivity

final class Session: NSObject, ObservableObject {
  static let shared = Session()

  @MainActor
  @Published
  var showFaceSharing = false

  private func updateFaceSharing(_ session: WCSession) {
    let activated = session.activationState == .activated
    let paired = session.isPaired

    DispatchQueue.main.async {
      self.showFaceSharing = activated && paired
    }
  }

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
    updateFaceSharing(session)
  }

  func sessionDidDeactivate(_ session: WCSession) {
    WCSession.default.activate()
  }

  func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    updateFaceSharing(session)
  }

  func sessionWatchStateDidChange(_ session: WCSession) {
    updateFaceSharing(session)
  }
}
