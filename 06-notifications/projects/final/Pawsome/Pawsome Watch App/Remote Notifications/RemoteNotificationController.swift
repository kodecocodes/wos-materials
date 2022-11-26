import WatchKit
import SwiftUI
import UserNotifications

final class RemoteNotificationController: WKUserNotificationHostingController<RemoteNotificationView> {
  static let categoryIdentifier = "lorem"

  private var model: RemoteNotificationModel!

  override var body: RemoteNotificationView {
    return RemoteNotificationView(model: model)
  }

  override func didReceive(_ notification: UNNotification) {
    let fmt = ISO8601DateFormatter()

    let content = notification.request.content
    let title = content.title
    let body = content.body

    guard
      let dateString = content.userInfo["date"] as? String,
      let date = fmt.date(from: dateString)
    else {
      model = RemoteNotificationModel(
        title: "Unknown",
        details: "Unknown",
        date: Date.now
      )

      return
    }

    model = RemoteNotificationModel(title: title, details: body, date: date)
  }

  override class var isInteractive: Bool { true }
  override class var sashColor: Color? {
    Color(red: 0, green: 156 / 255, blue: 83 / 255)
  }
  override class var titleColor: Color? { Color.purple }
  override class var subtitleColor: Color? { Color.orange }
  override class var wantsSashBlur: Bool { true }
}
