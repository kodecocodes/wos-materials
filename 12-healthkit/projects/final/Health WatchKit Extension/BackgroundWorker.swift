import Foundation
import WatchKit

final class BackgroundWorker {
  public func schedule(firstTime: Bool = false) {
    let minutes = firstTime ? 1 : 15

    let when = Calendar.current.date(
      byAdding: .minute,
      value: minutes,
      to: Date.now
      // swiftlint:disable:next force_unwrapping
    )!

    WKExtension
      .shared()
      .scheduleBackgroundRefresh(
        withPreferredDate: when,
        userInfo: nil
      ) { error in
        if let error = error {
          print("Unable to schedule: \(error.localizedDescription)")
        }
      }
  }

  public func perform(_ completion: (Bool) -> Void) {
    completion(true)
  }
}
