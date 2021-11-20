import ClockKit

struct UtilitarianSmall: ComplicationTemplateFactory {
  func template(for waterLevel: Tide) -> CLKComplicationTemplate {
    return CLKComplicationTemplateUtilitarianSmallFlat(
      textProvider: textProvider(for: waterLevel),
      imageProvider: CLKImageProvider(onePieceImage: waterLevel.image())
    )
  }
}
