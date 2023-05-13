import Foundation
import PushKit

final class PushNotificationProvider: NSObject {
  let registry = PKPushRegistry(queue: .main)

  override init() {
    super.init()

    registry.delegate = self
    registry.desiredPushTypes = [.complication]
  }
}

extension PushNotificationProvider: PKPushRegistryDelegate {
  func pushRegistry(
    _ registry: PKPushRegistry,
    didUpdate pushCredentials: PKPushCredentials,
    for type: PKPushType
  ) {
    let token = pushCredentials.token.reduce("") { $0 + String(format: "%02x", $1) }
    print(token)
  }

  func pushRegistry(
    _ registry: PKPushRegistry,
    didReceiveIncomingPushWith payload: PKPushPayload,
    for type: PKPushType
  ) async {
    // Called on the main queue based on the PKPushRegistry queue parameter.
    print(payload.dictionaryPayload)
    await ExtensionDelegate.updateActiveComplications()
  }
}
