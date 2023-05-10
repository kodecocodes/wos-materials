import ClockKit

struct ModularSmall: ComplicationTemplateFactory {
  func template(for temperature: Double) -> CLKComplicationTemplate {
    return CLKComplicationTemplateModularSmallSimpleText(
      textProvider: textProvider(for: temperature)
    )
  }
}
