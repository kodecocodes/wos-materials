import ClockKit
import SwiftUI

class ComplicationController: NSObject, CLKComplicationDataSource {
  func complicationDescriptors() async -> [CLKComplicationDescriptor] {
    return [
      .init(
        identifier: "com.raywenderlich.CalendarComplication",
        displayName: "Calendar",
        supportedFamilies: [.graphicRectangular]
      )
    ]
  }

  func currentTimelineEntry(for complication: CLKComplication) async -> CLKComplicationTimelineEntry? {
    return nil
  }
}
