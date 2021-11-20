import SwiftUI
import ClockKit

struct EventView: View {
  let event: Event

  private let formatter: DateIntervalFormatter = {
    let formatter = DateIntervalFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
  }()

  var body: some View {
    HStack {
      RoundedRectangle(cornerRadius: 3)
        .frame(width: 5)
        .foregroundColor(event.color)
        .complicationForeground()

      VStack(alignment: .leading) {
        Text(formatter.string(from: event.startDate, to: event.endDate))
          .font(.subheadline)

        Text(event.title)
          .font(.headline)
          .complicationForeground()

        if let location = event.location {
          Text(location)
            .font(.subheadline)
        }
      }
    }
  }
}

struct EventView_Previews: PreviewProvider {
  static var event = Event(
    color: .blue,
    startDate: .now,
    endDate: .now.addingTimeInterval(3600),
    title: "Gnomes rule!",
    location: "Everywhere"
  )

  static var previews: some View {
    Group {
      EventView(event: event)

      CLKComplicationTemplateGraphicRectangularFullView(
        EventView(event: event)
      )
        .previewContext(faceColor: .green)
    }
  }
}
