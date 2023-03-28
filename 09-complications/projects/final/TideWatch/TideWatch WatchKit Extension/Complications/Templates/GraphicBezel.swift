import ClockKit

struct GraphicBezel: ComplicationTemplateFactory {
  func template(for waterLevel: Tide) -> CLKComplicationTemplate {
    let circularTemplate = CLKComplicationTemplateGraphicCircularImage(
      imageProvider: fullColorImageProvider(for: waterLevel)
    )

    return CLKComplicationTemplateGraphicBezelCircularText(
      circularTemplate: circularTemplate,
      textProvider: textProvider(for: waterLevel, unitStyle: .long)
    )
  }
}
