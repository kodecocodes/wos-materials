import ClockKit

struct GraphicCircular: ComplicationTemplateFactory {
  func template(for temperature: Double) -> CLKComplicationTemplate {
    return CLKComplicationTemplateGraphicCircularStackImage(
      line1ImageProvider: fullColorImageProvider(),
      line2TextProvider: textProvider(for: temperature)
    )
  }
}
