import ClockKit

struct GraphicBezel: ComplicationTemplateFactory {
  func template(for temperature: Double) -> CLKComplicationTemplate {
    let circularTemplate = CLKComplicationTemplateGraphicCircularImage(
      imageProvider: fullColorImageProvider()
    )

    return CLKComplicationTemplateGraphicBezelCircularText(
      circularTemplate: circularTemplate,
      textProvider: textProvider(for: temperature, unitStyle: .long)
    )
  }
}
