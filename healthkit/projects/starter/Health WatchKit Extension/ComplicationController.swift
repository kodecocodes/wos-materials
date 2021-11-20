import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
  func currentTimelineEntry(for complication: CLKComplication) async -> CLKComplicationTimelineEntry? {
    return nil
  }
}
