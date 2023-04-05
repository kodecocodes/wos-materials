import Foundation

enum SnapshotError: Error {
  case noHandler, badDestination, badMatchId, noUserInfo
}

struct SnapshotUserInfo {
  let handler: () -> Void
  let destination: ContentView.Destination
  let matchId: Match.ID?

  private enum Keys: String {
    case handler, destination, matchId
  }

  init(
    handler: @escaping () -> Void,
    destination: ContentView.Destination,
    matchId: Match.ID? = nil
  ) {
    self.handler = handler
    self.destination = destination
    self.matchId = matchId
  }

  func encode() -> [AnyHashable: Any] {
    return [
      Keys.handler.rawValue: handler,
      Keys.destination.rawValue: destination,
      Keys.matchId.rawValue: matchId as Any
    ]
  }

  static func from(notification: Notification) throws -> Self {
    guard let userInfo = notification.userInfo else {
      throw SnapshotError.noHandler
    }

    guard let handler = userInfo[Keys.handler.rawValue] as? () -> Void else {
      throw SnapshotError.noHandler
    }

    guard
      let destination = userInfo[Keys.destination.rawValue] as? ContentView.Destination
    else {
      throw SnapshotError.badDestination
    }

    return .init(
      handler: handler,
      destination: destination,
      matchId: userInfo[Keys.matchId.rawValue] as? Match.ID
    )
  }
}
