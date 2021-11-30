import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
  func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
    handler(nil)
  }
}

