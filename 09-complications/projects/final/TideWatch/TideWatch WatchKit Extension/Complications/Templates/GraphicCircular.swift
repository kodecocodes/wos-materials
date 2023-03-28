import ClockKit

struct GraphicCircular: ComplicationTemplateFactory {
  func template(for waterLevel: Tide) -> CLKComplicationTemplate {
    return CLKComplicationTemplateGraphicCircularStackImage(
      line1ImageProvider: fullColorImageProvider(for: waterLevel),
      line2TextProvider: textProvider(for: waterLevel)
    )
  }
}
