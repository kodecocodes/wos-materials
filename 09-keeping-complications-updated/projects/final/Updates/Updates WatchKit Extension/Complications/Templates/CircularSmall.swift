import ClockKit

struct CircularSmall: ComplicationTemplateFactory {
  func template(for temperature: Double) -> CLKComplicationTemplate {
    return CLKComplicationTemplateCircularSmallSimpleText(
      textProvider: textProvider(for: temperature)
    )
  }
}
