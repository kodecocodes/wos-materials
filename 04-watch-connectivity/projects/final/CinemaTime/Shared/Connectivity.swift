import Foundation
import WatchConnectivity

final class Connectivity: NSObject, ObservableObject {
  @Published var purchasedIds: [Int] = []
  static let shared = Connectivity()
  
  override private init() {
    super.init()
    
#if !os(watchOS)
    guard WCSession.isSupported() else {
      return
    }
#endif
    
    WCSession.default.delegate = self
    
    WCSession.default.activate()
  }
  
  private func canSendToPeer() -> Bool {
    guard WCSession.default.activationState == .activated else {
      return false
    }
    
#if os(watchOS)
    guard WCSession.default.isCompanionAppInstalled else {
      return false
    }
#else
    guard WCSession.default.isWatchAppInstalled else {
      return false
    }
#endif
    
    return true
  }
  
  public func send(
    movieIds: [Int],
    delivery: Delivery,
    wantedQrCodes: [Int]? = nil,
    replyHandler: (([String: Any]) -> Void)? = nil,
    errorHandler: ((Error) -> Void)? = nil
  ) {
    guard canSendToPeer() else { return }
    
    var userInfo: [String: [Int]] = [
      ConnectivityUserInfoKey.purchased.rawValue: movieIds
    ]
    
    if let wantedQrCodes {
      let key = ConnectivityUserInfoKey.qrCodes.rawValue
      userInfo[key] = wantedQrCodes
    }
    
    switch delivery {
    case .failable:
      WCSession.default.sendMessage(
        userInfo,
        replyHandler: optionalMainQueueDispatch(handler: replyHandler),
        errorHandler: optionalMainQueueDispatch(handler: errorHandler)
      )
      
    case .guaranteed:
      WCSession.default.transferUserInfo(userInfo)
      
    case .highPriority:
      do {
        try WCSession.default.updateApplicationContext(userInfo)
      } catch {
        errorHandler?(error)
      }
    }
  }
  
  public func send(
    data: Data,
    replyHandler: ((Data) -> Void)? = nil,
    errorHandler: ((Error) -> Void)? = nil
  ) {
    guard canSendToPeer() else { return }
    
    WCSession.default.sendMessageData(
      data,
      replyHandler: optionalMainQueueDispatch(handler: replyHandler),
      errorHandler: optionalMainQueueDispatch(handler: errorHandler)
    )
  }
  
  private func update(from dictionary: [String: Any]) {
#if os(iOS)
    sendQrCodes(dictionary)
#endif
    
    let key = ConnectivityUserInfoKey.purchased.rawValue
    guard let ids = dictionary[key] as? [Int] else {
      return
    }
    
    self.purchasedIds = ids
  }
  
  typealias OptionalHandler<T> = ((T) -> Void)?
  
  private func optionalMainQueueDispatch<T>(handler: OptionalHandler<T>) -> OptionalHandler<T> {
    guard let handler = handler else {
      return nil
    }
    
    return { item in
      Task { @MainActor in
        handler(item)
      }
    }
  }
  
#if os(iOS)
  public func sendQrCodes(_ data: [String: Any]) {
    // 1
    let key = ConnectivityUserInfoKey.qrCodes.rawValue
    guard let ids = data[key] as? [Int], !ids.isEmpty else { return }
    
    let tempDir = FileManager.default.temporaryDirectory
    
    // 2
    TicketOffice.shared
      .movies
      .filter { ids.contains($0.id) }
      .forEach { movie in
        // 3
        let image = QRCode.generate(
          movie: movie,
          size: .init(width: 100, height: 100)
        )
        
        // 4
        guard let data = image?.pngData() else { return }
        
        // 5
        let url = tempDir.appendingPathComponent(UUID().uuidString)
        guard let _ = try? data.write(to: url) else {
          return
        }
        
        // 6
        WCSession.default.transferFile(url, metadata: [key: movie.id])
      }
  }
#endif
}

// MARK: - WCSessionDelegate
extension Connectivity: WCSessionDelegate {
  func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
  }
  
#if os(iOS)
  func sessionDidBecomeInactive(_ session: WCSession) {
  }
  
  func sessionDidDeactivate(_ session: WCSession) {
    // If the person has more than one watch, and they switch,
    // reactivate their session on the new device.
    WCSession.default.activate()
  }
#endif
  
  func session(
    _ session: WCSession,
    didReceiveApplicationContext applicationContext: [String: Any]
  ) {
    update(from: applicationContext)
  }
  
  func session(
    _ session: WCSession,
    didReceiveUserInfo userInfo: [String: Any] = [:]
  ) {
    update(from: userInfo)
  }
  
  // This method is called when a message is sent with failable priority *and* a reply was requested.
  func session(
    _ session: WCSession,
    didReceiveMessage message: [String: Any],
    replyHandler: @escaping ([String: Any]) -> Void
  ) {
    update(from: message)
    
    let key = ConnectivityUserInfoKey.verified.rawValue
    replyHandler([key: true])
  }
  
  // This method is called when a message is sent with failable priority and a reply was *not* requested.
  func session(
    _ session: WCSession,
    didReceiveMessage message: [String: Any]
  ) {
    update(from: message)
  }
  
  func session(
    _ session: WCSession,
    didReceiveMessageData messageData: Data
  ) {
  }
  
  func session(
    _ session: WCSession,
    didReceiveMessageData messageData: Data,
    replyHandler: @escaping (Data) -> Void
  ) {
  }
  
#if os(watchOS)
  func session(_ session: WCSession, didReceive file: WCSessionFile) {
    let key = ConnectivityUserInfoKey.qrCodes.rawValue
    guard let id = file.metadata?[key] as? Int else {
      return
    }
    
    let destination = QRCode.url(for: id)
    
    try? FileManager.default.removeItem(at: destination)
    try? FileManager.default.moveItem(at: file.fileURL, to: destination)
  }
#endif
}
