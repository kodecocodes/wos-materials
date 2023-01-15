import ClockKit

struct GraphicCorner: ComplicationTemplateFactory {
  func template(for waterLevel: Tide) -> CLKComplicationTemplate {
    return CLKComplicationTemplateGraphicCornerTextImage(
      textProvider: textProvider(for: waterLevel, unitStyle: .medium),
      imageProvider: fullColorImageProvider(for: waterLevel)
    )
  }
}
