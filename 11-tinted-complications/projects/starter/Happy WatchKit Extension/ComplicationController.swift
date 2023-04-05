import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
  func complicationDescriptors() async -> [CLKComplicationDescriptor] {
    return [
      .init(
        identifier: "com.kodeco.Happy",
        displayName: "Happy",
        supportedFamilies: [
          .graphicExtraLarge
        ]
      )
    ]
  }

  func currentTimelineEntry(for complication: CLKComplication) async -> CLKComplicationTimelineEntry? {
    let template = await localizableSampleTemplate(for: complication)!
    return .init(date: Date.now, complicationTemplate: template)
  }

  func localizableSampleTemplate(for complication: CLKComplication) async -> CLKComplicationTemplate? {
    guard let full = UIImage(named: "Full") else {
      fatalError("Full.png is missing from asset catalog.")
    }

    return CLKComplicationTemplateGraphicExtraLargeCircularImage(
      imageProvider: CLKFullColorImageProvider(fullColorImage: full)
    )
  }
}
