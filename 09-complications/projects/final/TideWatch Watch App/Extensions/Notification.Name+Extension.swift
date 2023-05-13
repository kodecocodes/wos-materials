import Foundation

extension Notification.Name {
  static let currentTideUpdated = Notification.Name(rawValue: UUID().uuidString)
  static let averageWaterHeight = Notification.Name(rawValue: UUID().uuidString)
}
