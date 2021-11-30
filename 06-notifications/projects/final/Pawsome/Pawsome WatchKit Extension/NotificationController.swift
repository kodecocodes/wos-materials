import WatchKit
import SwiftUI
import UserNotifications

class NotificationController: WKUserNotificationHostingController<NotificationView> {
  var image: Image!
  var message: String!

  override var body: NotificationView {
    return NotificationView(message: message, image: image)
  }

  override func didReceive(_ notification: UNNotification) {
    let content = notification.request.content
    message = content.body

    let validRange = 1...20

    if
      let imageNumber = content.userInfo["imageNumber"] as? Int,
      validRange ~= imageNumber {
      image = Image("cat\(imageNumber)")
    } else {
      let num = Int.random(in: validRange)
      image = Image("cat\(num)")
    }
  }
}
