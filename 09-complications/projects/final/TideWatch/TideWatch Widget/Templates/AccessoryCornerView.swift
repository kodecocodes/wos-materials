import SwiftUI
import WidgetKit

struct AccessoryCornerView: View {
  let tide: Tide

  var body: some View {
    tide
      .image()
      .widgetLabel {
        Text("\(tide.heightString()) @ \(tide.date, style: .time)")
          .font(.caption)
          .widgetAccentable()
      }
  }
}

struct AccessoryCornerView_Previews: PreviewProvider {
  static var previews: some View {
    AccessoryCornerView(tide: Tide.placeholder())
      .previewContext(WidgetPreviewContext(family: .accessoryCorner))
  }
}
