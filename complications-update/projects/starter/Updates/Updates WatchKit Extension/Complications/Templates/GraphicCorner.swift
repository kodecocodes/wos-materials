import ClockKit

struct GraphicCorner: ComplicationTemplateFactory {
  func template(for temperature: Double) -> CLKComplicationTemplate {
    return CLKComplicationTemplateGraphicCornerTextImage(
      textProvider: textProvider(for: temperature),
      imageProvider: fullColorImageProvider()
    )
  }
}
