import ClockKit
import SwiftUI

protocol ComplicationTemplateFactory {
  func template(for waterLevel: Tide) -> CLKComplicationTemplate
  func templateForSample() -> CLKComplicationTemplate
  func textProvider(for waterLevel: Tide, unitStyle: Formatter.UnitStyle) -> CLKSimpleTextProvider
  func fullColorImageProvider(for waterLevel: Tide) -> CLKFullColorImageProvider
  func plainImageProvider(for waterLevel: Tide) -> CLKImageProvider
}

extension ComplicationTemplateFactory {
  func templateForSample() -> CLKComplicationTemplate {
    _ = PersistenceController.shared.container

    let tide = Tide(entity: Tide.entity(), insertInto: nil)
    tide.date = Date()
    tide.height = 24
    tide.type = .falling

    return template(for: tide)
  }

  func textProvider(
    for waterLevel: Tide,
    unitStyle: Formatter.UnitStyle = .short
  ) -> CLKSimpleTextProvider {
    let shortText = waterLevel.heightString(unitStyle: unitStyle)
    let longText = "\(waterLevel.type.rawValue.capitalized), \(shortText)"

    return .init(text: longText, shortText: shortText)
  }

  func fullColorImageProvider(for waterLevel: Tide) -> CLKFullColorImageProvider {
    .init(fullColorImage: waterLevel.image())
  }

  func plainImageProvider(for waterLevel: Tide) -> CLKImageProvider {
    .init(onePieceImage: waterLevel.image())
  }
}
