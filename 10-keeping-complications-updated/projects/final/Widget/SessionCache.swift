import Foundation
import WidgetKit

final class SessionData {
  let session: URLSession
  var sessionCompletion: (() -> Void)? = nil
  var downloadCompletion: (([Tide]) -> ())? = nil
  var messageData: Data

  init(session: URLSession) {
    self.session = session
    messageData = Data()
  }
}

final class SessionCache: NSObject {
  static let shared = SessionCache()

  var sessions: [String: SessionData] = [:]

  private override init() {}

  func sessionData(for stationId: MeasurementStation.ID) -> SessionData {
    if let data = sessions[stationId] {
      return data
    }

    let session = URLSession(
      configuration: .background(withIdentifier: stationId),
      delegate: self,
      delegateQueue: nil
    )

    let data = SessionData(session: session)
    sessions[stationId] = data

    return data
  }

  func isValid(for stationId: MeasurementStation.ID) -> Bool {
    return sessions[stationId] != nil
  }
}

extension SessionCache: URLSessionDelegate {
  func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    guard let stationId = session.configuration.identifier else {
      return
    }

    let sessionData = SessionCache.shared.sessionData(for: stationId)
    let tides = CoOpsApi.shared
      .decodeTideData(data: sessionData.messageData)

    DispatchQueue.main.async {
      sessionData.sessionCompletion?()
      sessionData.downloadCompletion?(tides)
    }
  }
}

extension SessionCache: URLSessionDataDelegate {
  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    guard let stationId = session.configuration.identifier else {
      return
    }

    let sessionData = SessionCache.shared.sessionData(for: stationId)
    sessionData.messageData += data
  }
}
