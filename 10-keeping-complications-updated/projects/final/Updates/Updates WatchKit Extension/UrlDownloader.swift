import Foundation

final class UrlDownloader: NSObject {
  private var backgroundTask: URLSessionDownloadTask?
  private var completionHandler: ((Bool) -> Void)?
  
  let identifier: String

  init(identifier: String) {
    self.identifier = identifier
  }

  private lazy var backgroundUrlSession: URLSession = {
    let config = URLSessionConfiguration.background(withIdentifier: identifier)
    config.isDiscretionary = false
    config.sessionSendsLaunchEvents = true

    return .init(configuration: config, delegate: self, delegateQueue: nil)
  }()

  func schedule(firstTime: Bool = false) {
    let minutes = firstTime ? 1 : 15

    // swiftlint:disable:next force_unwrapping
    let when = Calendar.current.date(byAdding: .minute, value: minutes, to: Date.now)!

    // swiftlint:disable:next force_unwrapping
    let url = URL(string: "https://api.weather.gov/gridpoints/TOP/31,80/forecast")!
    let task = backgroundUrlSession.downloadTask(with: url)
    task.earliestBeginDate = when

    task.countOfBytesClientExpectsToSend = 100
    task.countOfBytesClientExpectsToReceive = 12_000
    task.resume()

    backgroundTask = task
  }

  public func perform(_ completionHandler: @escaping (Bool) -> Void) {
    self.completionHandler = completionHandler
    _ = backgroundUrlSession
  }
}

extension UrlDownloader: URLSessionDownloadDelegate {
  func urlSession(
    _ session: URLSession,
    downloadTask: URLSessionDownloadTask,
    didFinishDownloadingTo location: URL
  ) {
    let decoder = JSONDecoder()

    guard
      location.isFileURL,
      let data = try? Data(contentsOf: location),
      let decoded = try? decoder.decode(Weather.self, from: data),
      let temperature = decoded.properties.periods.first?.temperature
    else {
      return
    }

    UserDefaults.standard.set(temperature, forKey: "temperature")

    ExtensionDelegate.updateActiveComplications()
  }

  func urlSession(
    _ session: URLSession,
    task: URLSessionTask,
    didCompleteWithError error: Error?
  ) {
    backgroundTask = nil

    DispatchQueue.main.async {
      self.completionHandler?(error == nil)
      self.completionHandler = nil
    }
  }
}
