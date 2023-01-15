import ClockKit

struct UtilitarianLarge: ComplicationTemplateFactory {
  func template(for waterLevel: Tide) -> CLKComplicationTemplate {
    return CLKComplicationTemplateUtilitarianLargeFlat(
      textProvider: textProvider(for: waterLevel, unitStyle: .long),
      imageProvider: CLKImageProvider(onePieceImage: waterLevel.image())
    )
  }
}
