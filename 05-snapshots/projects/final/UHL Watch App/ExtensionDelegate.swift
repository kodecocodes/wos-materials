import WatchKit

final class ExtensionDelegate: NSObject, WKExtensionDelegate {
  func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
    backgroundTasks.forEach { task in
      guard let snapshot = task as? WKSnapshotRefreshBackgroundTask else {
        task.setTaskCompletedWithSnapshot(false)
        return
      }

      print("Taking a snapshot")

      let nextSnapshotDate = nextSnapshotDate()

      let handler = {
        snapshot.setTaskCompleted(
          restoredDefaultState: false,
          estimatedSnapshotExpiration: nextSnapshotDate,
          userInfo: nil
        )
      }

      var snapshotUserInfo: SnapshotUserInfo?

      if lastMatchPlayedRecently() {
        print("Going to record")
        snapshotUserInfo = SnapshotUserInfo(
          handler: handler,
          destination: .record
        )
      } else if let id = idForPendingMatch() {
        print("Going to schedule")
        snapshotUserInfo = SnapshotUserInfo(
          handler: handler,
          destination: .schedule,
          matchId: id
        )
      }

      if let snapshotUserInfo = snapshotUserInfo {
        NotificationCenter.default.post(
          name: .pushViewForSnapshot,
          object: nil,
          userInfo: snapshotUserInfo.encode()
        )
      } else {
        handler()
      }
    }
  }

  private func idForPendingMatch() -> Match.ID? {
    guard let match = Season.shared.nextMatch else {
      return nil
    }

    let date = match.date
    let calendar = Calendar.current

    if calendar.isDateInTomorrow(date) || calendar.isDateInToday(date) {
      return match.id
    } else {
      return nil
    }
  }

  private func nextSnapshotDate() -> Date {
    guard let nextMatch = Season.shared.nextMatch else {
      return .distantFuture
    }

    let twoDaysLater = Calendar.current.date(
      byAdding: .day,
      value: 2,
      to: nextMatch.date
    )!

    return Calendar.current.startOfDay(for: twoDaysLater)
  }

  private func lastMatchPlayedRecently() -> Bool {
    guard let last = Season.shared.pastMatches().last?.date else {
      return false
    }

    return Calendar.current.isDateInYesterday(last) ||
           Calendar.current.isDateInToday(last)
  }
}
