import Foundation

extension UserDefaults {
  static let suiteName = "group.com.yourcompany.TideWatch"
  static let extensions = UserDefaults(suiteName: suiteName)!
}
