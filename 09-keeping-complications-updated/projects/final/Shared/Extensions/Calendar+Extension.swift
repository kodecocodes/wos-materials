import Foundation

extension Calendar {
  static let utc: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC")!

    return calendar
  }()

  func utcHour() -> Date {
    let components = Self.utc.dateComponents([.era, .year, .month, .day, .hour], from: Date.now)

    return Self.utc.date(from: components)!
  }
}
