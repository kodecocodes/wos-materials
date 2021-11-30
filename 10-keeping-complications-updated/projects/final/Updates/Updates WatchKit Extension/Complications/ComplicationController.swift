import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
  func complicationDescriptors() async -> [CLKComplicationDescriptor] {
    return [
      .init(
        identifier: "com.raywenderlich.Updates",
        displayName: "Updates",
        supportedFamilies: [
          .circularSmall, .extraLarge, .graphicBezel, .graphicCircular, .graphicCorner,
          .modularSmall, .utilitarianLarge, .utilitarianSmall, .utilitarianSmallFlat
        ]
      )
    ]
  }

  func currentTimelineEntry(for complication: CLKComplication) async -> CLKComplicationTimelineEntry? {
    guard let factory = Self.generate(for: complication) else {
      return nil
    }

    let temperature = UserDefaults.standard.double(forKey: "temperature")

    return .init(
      date: Date.now,
      complicationTemplate: factory.template(for: temperature)
    )
  }

  static func generate(
    for complication: CLKComplication
  ) -> ComplicationTemplateFactory? {
    switch complication.family {
    case .circularSmall: return CircularSmall()
    case .extraLarge: return ExtraLarge()
    case .graphicBezel: return GraphicBezel()
    case .graphicCircular: return GraphicCircular()
    case .graphicCorner: return GraphicCorner()
    case .modularSmall: return ModularSmall()
    case .modularLarge: return ModularLarge()
    case .utilitarianLarge: return UtilitarianLarge()
    case .utilitarianSmall, .utilitarianSmallFlat:
      return UtilitarianSmall()

    default:
      return nil
    }
  }

  func localizableSampleTemplate(for complication: CLKComplication) async -> CLKComplicationTemplate? {
    return Self.generate(for: complication)?.templateForSample()
  }
}
