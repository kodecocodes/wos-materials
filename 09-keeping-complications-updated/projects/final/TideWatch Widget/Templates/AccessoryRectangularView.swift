import SwiftUI
import WidgetKit

struct AccessoryRectangularView: View {
  let tide: Tide?
  let stationName: String?

  var body: some View {
    if let tide {
      HStack {
        VStack(alignment: .leading) {
          Text(tide.heightString(unitStyle: .long))
            .font(.headline)
            .foregroundColor(.blue)
            .widgetAccentable()
          Text("@ \(tide.date.formatted(date: .omitted, time: .shortened))")
            .font(.caption)

          if let stationName {
            Text(stationName)
              .font(.caption)
          }
        }

        tide.image()
          .font(.headline.bold())
      }
    } else {
      VStack(alignment: .leading) {
        if let stationName {
          Text(stationName)
        }
        Text("No data")
      }
    }
  }
}

struct AccessoryRectangular_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      AccessoryRectangularView(tide: Tide.placeholder(), stationName: "Foo")
        .previewContext(WidgetPreviewContext(family: .accessoryRectangular))

      AccessoryRectangularView(tide: nil, stationName: "Foo")
        .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
  }
}
