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

  private init() {
    date = Date.now
    height = Double.random(in: 1 ... 20)
    type = TideType.allCases.randomElement()!
  }

  func heightString(unitStyle: Formatter.UnitStyle = .short) -> String {
    let heightMeters = Measurement(value: height, unit: UnitLength.meters)
    return Formatters.heightString(from: heightMeters, unitStyle: unitStyle)
  }

  func image() -> Image {
    switch type {
    case .unknown:
      return Image(systemName: "water.waves.slash")
    case .rising:
      return Image(systemName: "water.waves.and.arrow.up")
    case .low:
      return Image("tide_low")
    case .high:
      return Image(systemName: "water.waves")
    case .falling:
      return Image(systemName: "water.waves.and.arrow.down")
    }
  }

  static func placeholder() -> Tide {
    return Tide()
  }
}

