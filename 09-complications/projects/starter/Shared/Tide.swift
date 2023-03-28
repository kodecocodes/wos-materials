import SwiftUI

final class Tide: Codable {
  let date: Date
  let height: Double
  var type: TideType

  init(on date: Date, at height: Double) {
    self.date = date
    self.height = height
    type = .unknown
  }

  func heightString(unitStyle: Formatter.UnitStyle = .short) -> String {
    let heightMeters = Measurement(value: height, unit: UnitLength.meters)
    return Formatters.heightString(from: heightMeters, unitStyle: unitStyle)
  }

  func image() -> Image {
    let imageName = type == .unknown ? "high" : type.rawValue

    return Image("tide_\(imageName)")
  }

  static func placeholder() -> Tide {
    let tide = Tide(on: Date.now, at: .random(in: 1 ... 20))
    tide.type = TideType.allCases.randomElement()!

    return tide
  }
}
