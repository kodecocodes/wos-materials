import SwiftUI
import EventKit
import Combine
import ClockKit

@MainActor
final class EventStore: ObservableObject {
  static let shared = EventStore()

  @Published var calendarAccessGranted = false
  @Published var nextEvent: EKEvent? {
    didSet {
      let server = CLKComplicationServer.sharedInstance()
      server.activeComplications?.forEach {
        server.reloadTimeline(for: $0)
      }
    }
  }

  private let eventStore = EKEventStore()
  private var subscribers: Set<AnyCancellable> = []

  private init() {
    NotificationCenter.default.publisher(for: .EKEventStoreChanged)
      .sink { [unowned self] _ in
        self.assignNextCalendarEvent()
      }
      .store(in: &subscribers)

    assignNextCalendarEvent()
  }

  func requestAccess() {
    let status = EKEventStore.authorizationStatus(for: .event)

    switch status {
    case .notDetermined:
      eventStore.requestAccess(to: .event) { granted, _ in
        DispatchQueue.main.async {
          self.calendarAccessGranted = granted
        }
      }

    case .authorized:
      calendarAccessGranted = true
      break

    default:
      calendarAccessGranted = false
    }
  }

  func eventsForToday() -> [EKEvent]? {
    guard EKEventStore.authorizationStatus(for: .event) == .authorized else {
      return nil
    }

    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date.now)!
    let startOfTomorrow = Calendar.current.startOfDay(for: tomorrow)
    let endOfToday = startOfTomorrow.addingTimeInterval(-1)

    let predicate = eventStore.predicateForEvents(
      withStart: Date.now,
      end: endOfToday,
      calendars: nil
    )

    return eventStore.events(matching: predicate)
      .filter { !$0.isAllDay }
      .sorted { $0.compareStartDate(with: $1) == .orderedAscending }
  }

  private func assignNextCalendarEvent() {
    Task {
      let event = eventsForToday()?.first

      await MainActor.run {
        nextEvent = event
      }
    }
  }
}

