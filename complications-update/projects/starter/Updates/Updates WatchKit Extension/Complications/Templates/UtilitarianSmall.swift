import ClockKit

struct UtilitarianSmall: ComplicationTemplateFactory {
  func template(for temperature: Double) -> CLKComplicationTemplate {
    return CLKComplicationTemplateUtilitarianSmallFlat(
      textProvider: textProvider(for: temperature),
      imageProvider: plainImageProvider()
    )
  }
}
