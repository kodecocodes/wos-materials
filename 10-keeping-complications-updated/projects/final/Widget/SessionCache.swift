import Foundation
import WidgetKit

final class SessionData {
  let session: URLSession
  var sessionCompletion: (() -> Void)? = nil
  var downloadCompletion: (([Tide]) -> ())? = nil

  init(session: URLSession) {
    self.session = session
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

  private func downloadCompleted(for session: URLSession, data: Data? = nil) {
    guard let stationId = session.configuration.identifier else {
      return
    }

    let sessionData = SessionCache.shared.sessionData(for: stationId)
    let tides = data == nil ? [] : CoOpsApi.shared.decodeTideData(data: data)

    DispatchQueue.main.async {
      sessionData.sessionCompletion?()
      sessionData.sessionCompletion = nil

      sessionData.downloadCompletion?(tides)
      sessionData.downloadCompletion = nil
    }
  }
}

extension SessionCache: URLSessionDownloadDelegate {
  func urlSession(
    _ session: URLSession,
    downloadTask: URLSessionDownloadTask,
    didFinishDownloadingTo location: URL
  ) {
    guard
      location.isFileURL,
      let data = try? Data(contentsOf: location)
    else {
      downloadCompleted(for: session)
      return
    }

    downloadCompleted(for: session, data: data)
  }

  func urlSession(
    _ session: URLSession,
    task: URLSessionTask,
    didCompleteWithError error: Error?
  ) {
    downloadCompleted(for: session)
  }
}

