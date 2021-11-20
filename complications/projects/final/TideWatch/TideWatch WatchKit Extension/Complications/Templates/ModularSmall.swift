import ClockKit

struct ModularSmall: ComplicationTemplateFactory {
  func template(for waterLevel: Tide) -> CLKComplicationTemplate {
    return CLKComplicationTemplateModularSmallSimpleText(
      textProvider: textProvider(for: waterLevel)
    )
  }
}
