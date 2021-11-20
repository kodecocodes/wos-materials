import ClockKit
import CoreData

class ComplicationController: NSObject, CLKComplicationDataSource {
  func complicationDescriptors() async -> [CLKComplicationDescriptor] {
    return [
      .init(
        identifier: "com.raywenderlich.TideWatch",
        displayName: "Tide Conditions",
        supportedFamilies: [
          .circularSmall, .extraLarge, .graphicBezel, .graphicCircular, .graphicCorner,
          .modularSmall, .utilitarianLarge, .utilitarianSmall, .utilitarianSmallFlat
        ]
      )
    ]
  }

  func currentTimelineEntry(for complication: CLKComplication) async -> CLKComplicationTimelineEntry? {
    guard
      let factory = ComplicationTemplates.generate(for: complication),
      let tide = Tide.getCurrent()
    else {
      return nil
    }

    let template = factory.template(for: tide)
    return .init(date: tide.date, complicationTemplate: template)
  }

  func localizableSampleTemplate(for complication: CLKComplication) async -> CLKComplicationTemplate? {
    return ComplicationTemplates.generate(for: complication)?.templateForSample()
  }
}
