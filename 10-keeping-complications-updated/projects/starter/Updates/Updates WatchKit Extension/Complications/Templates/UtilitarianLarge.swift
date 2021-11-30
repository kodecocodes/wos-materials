import ClockKit

struct UtilitarianLarge: ComplicationTemplateFactory {
  func template(for temperature: Double) -> CLKComplicationTemplate {
    return CLKComplicationTemplateUtilitarianLargeFlat(
      textProvider: textProvider(for: temperature, unitStyle: .long),
      imageProvider: plainImageProvider()
    )
  }
}
