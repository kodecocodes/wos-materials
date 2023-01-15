import SwiftUI

final class Tide: Codable {
  let date: Date
  let height: Double
  var type: TideType
  var msg: String = "X"

  var hasData: Bool { height >= 0}

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
    switch type {
    case .falling:
      return Image(systemName: "water.waves.and.arrow.down")

    case .high:
      return Image(systemName: "water.waves")

    case .low:
      return Image("tide_low")

    case .rising:
      return Image(systemName: "water.waves.and.arrow.up")

    case .unknown:
      return Image(systemName: "questionmark")
    }
  }

  static func noData() -> Tide {
    .init(on: Date.now, at: -1)
  }

  static func placeholder() -> Tide {
    let tide = Tide(on: Date.now, at: .random(in: 1 ... 20))
    tide.type = TideType.allCases.randomElement()!

    return tide
  }
}

