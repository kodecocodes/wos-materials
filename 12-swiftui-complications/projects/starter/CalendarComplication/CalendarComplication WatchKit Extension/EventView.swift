import SwiftUI
import EventKit

struct EventView: View {
  @ObservedObject private var eventStore = EventStore.shared

  var body: some View {
    VStack {
      if eventStore.calendarAccessGranted == false {
        Text("This app requires calendar permission.")
      } else if let event = eventStore.nextEvent {
        Text("Hello, World!")
      } else {
        Text("No more events today.")
      }
    }
    .task {
      eventStore.requestAccess()
    }
  }
}

struct EventView_Previews: PreviewProvider {
  static var previews: some View {
    EventView()
  }
}
