import SwiftUI
import WidgetKit

struct AccessoryRectangularView: View {
  let tide: Tide
  let stationName: String

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 0) {
        Text("Height: \(tide.heightString())")
          .font(.headline)
          .widgetAccentable()

        Text("As of: \(tide.date, style: .time)")
        Text(stationName)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      tide.image()
    }
  }
}

struct AccessoryRectangularView_Previews: PreviewProvider {
  static var previews: some View {
    AccessoryRectangularView(tide: Tide.placeholder(), stationName: "Sample")
      .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
  }
}
