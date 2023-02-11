import Foundation

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

  private func downloadCompleted(for session: URLSession, data: Data? = nil) {
    guard let stationId = session.configuration.identifier else {
      return
    }

    let tides = data == nil ? [] : CoOpsApi.shared.decodeTide(data)
    let sessionData = SessionCache.shared.sessionData(for: stationId)

    DispatchQueue.main.async {
      sessionData.downloadCompletion?(tides)
      sessionData.downloadCompletion = nil

      sessionData.sessionCompletion?()
      sessionData.sessionCompletion = nil
    }
  }

  func isValid(for stationId: MeasurementStation.ID) -> Bool {
    return sessions[stationId] != nil
  }
}

extension SessionCache: URLSessionDownloadDelegate {
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {

  }

  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

  }
}


