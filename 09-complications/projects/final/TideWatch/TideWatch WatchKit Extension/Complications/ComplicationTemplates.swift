import ClockKit

enum ComplicationTemplates {
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
}
