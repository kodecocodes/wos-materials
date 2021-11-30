import SwiftUI
import EventKit

struct Event {
  let color: Color
  let startDate: Date
  let endDate: Date
  let title: String
  let location: String?

  init(ekEvent: EKEvent) {
    color = Color(ekEvent.calendar.cgColor)
    startDate = ekEvent.startDate
    endDate = ekEvent.endDate
    title = ekEvent.title
    location = ekEvent.location
  }

  init(
    color: Color,
    startDate: Date,
    endDate: Date,
    title: String,
    location: String?
  ) {
    self.color = color
    self.startDate = startDate
    self.endDate = endDate
    self.title = title
    self.location = location
  }
}
