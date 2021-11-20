import ClockKit

struct CircularSmall: ComplicationTemplateFactory {
  func template(for waterLevel: Tide) -> CLKComplicationTemplate {
    return CLKComplicationTemplateCircularSmallSimpleText(
      textProvider: textProvider(for: waterLevel)
    )
  }
}
