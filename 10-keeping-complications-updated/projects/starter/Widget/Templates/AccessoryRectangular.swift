import SwiftUI
import WidgetKit

struct AccessoryRectangular: View {
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
    }
  }
}

struct AccessoryRectangular_Previews: PreviewProvider {
  static var previews: some View {
    AccessoryRectangular(tide: Tide.placeholder())
      .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
  }
}
