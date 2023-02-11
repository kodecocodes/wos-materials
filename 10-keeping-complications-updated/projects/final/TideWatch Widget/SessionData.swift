import Foundation

final class SessionData {
  let session: URLSession
  var downloadCompletion: (([Tide]) -> Void)? = nil
  var sessionCompletion: (() -> Void)? = nil

  init(session: URLSession) {
    self.session = session
  }
}
