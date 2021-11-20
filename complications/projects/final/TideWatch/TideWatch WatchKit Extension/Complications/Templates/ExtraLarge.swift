import ClockKit

struct ExtraLarge: ComplicationTemplateFactory {
  func template(for waterLevel: Tide) -> CLKComplicationTemplate {
    return CLKComplicationTemplateExtraLargeStackImage(
      line1ImageProvider: plainImageProvider(for: waterLevel),
      line2TextProvider: textProvider(for: waterLevel, unitStyle: .long)
    )
  }
}
