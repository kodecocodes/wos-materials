import Foundation

enum Formatters {
  static let predictionInputFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd HH:mm"
    formatter.timeZone = TimeZone(identifier: "UTC")

    return formatter
  }()

  static let predictionOutputFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    formatter.timeZone = TimeZone(identifier: "UTC")

    return formatter
  }()

  private static let heightFormatter: MeasurementFormatter = {
    let formatter = MeasurementFormatter()
    formatter.unitOptions = .naturalScale
    formatter.numberFormatter?.maximumFractionDigits = 1

    return formatter
  }()

  static func heightString(from measurement: Measurement<UnitLength>, unitStyle: Formatter.UnitStyle = .short) -> String {
    heightFormatter.unitStyle = unitStyle
    return heightFormatter.string(from: measurement)
  }
}
