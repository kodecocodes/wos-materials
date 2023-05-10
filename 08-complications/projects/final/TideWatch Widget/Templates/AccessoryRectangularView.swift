import SwiftUI
import WidgetKit

struct AccessoryRectangularView: View {
  let tide: Tide

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(tide.heightString(unitStyle: .long))
          .font(.headline)
          .foregroundColor(.blue)
          .widgetAccentable()
        Text(tide.date.formatted(date: .omitted, time: .shortened))
          .font(.caption)
        Text(tide.type.rawValue.capitalized)
          .font(.caption)
      }

      tide.image()
        .font(.headline.bold())
        .widgetAccentable()
    }
  }
}

struct AccessoryRectangularView_Previews: PreviewProvider {
  static var previews: some View {
    AccessoryRectangularView(tide: Tide.placeholder())
      .previewContext(WidgetPreviewContext(family: .accessoryRectangular))

  }
}
