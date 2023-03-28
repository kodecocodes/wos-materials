import ClockKit

struct ExtraLarge: ComplicationTemplateFactory {
  func template(for temperature: Double) -> CLKComplicationTemplate {
    return CLKComplicationTemplateExtraLargeSimpleText(
      textProvider: textProvider(for: temperature)
    )
  }
}
