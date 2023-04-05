import ClockKit
import SwiftUI
import EventKit

class ComplicationController: NSObject, CLKComplicationDataSource {
  func complicationDescriptors() async -> [CLKComplicationDescriptor] {
    return [
      .init(
        identifier: "com.kodeco.CalendarComplication",
        displayName: "Calendar",
        supportedFamilies: [.graphicRectangular]
      )
    ]
  }

  func currentTimelineEntry(for complication: CLKComplication) async -> CLKComplicationTimelineEntry? {
    return timelineEntry(for: EventStore.shared.nextEvent)
  }

  private func timelineEntry(for ekEvent: EKEvent?) -> CLKComplicationTimelineEntry {
    let event: Event?
    if let ekEvent = ekEvent {
      event = Event(ekEvent: ekEvent)
    } else {
      event = nil
    }

    let template = CLKComplicationTemplateGraphicRectangularFullView(
      EventComplicationView(event: event)
    )

    return .init(
      date: event?.startDate ?? .now,
      complicationTemplate: template
    )
  }

  func timelineEntries(
    for complication: CLKComplication,
    after date: Date,
    limit: Int
  ) async -> [CLKComplicationTimelineEntry]? {
    guard let events = EventStore.shared.eventsForToday() else {
      return [timelineEntry(for: nil)]
    }

    let wanted = events
      .filter {
        date.compare($0.startDate) == .orderedAscending
      }
      .prefix(limit)
      .map { timelineEntry(for: $0) }

    return wanted.count > 0 ? wanted : [timelineEntry(for: nil)]
  }

  func localizableSampleTemplate(
    for complication: CLKComplication
  ) async -> CLKComplicationTemplate? {
    let start = Calendar.current.date(
      bySettingHour: 10, minute: 0, second: 0, of: .now
    )!

    let end = Calendar.current.date(
      byAdding: .hour, value: 1, to: start
    )!

    return CLKComplicationTemplateGraphicRectangularFullView(
      EventView(event: .init(
        color: .blue,
        startDate: start,
        endDate: end,
        title: "Gnomes rule!",
        location: "Everywhere"
      ))
    )
  }
}
