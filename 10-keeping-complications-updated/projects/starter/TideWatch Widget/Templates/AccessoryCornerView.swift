import SwiftUI
import WidgetKit

struct AccessoryCornerView: View {
  let tide: Tide

  var body: some View {
    ZStack {
      AccessoryWidgetBackground()
      tide.image()
        .font(.title.bold())
    }
    .widgetLabel {
      Text(tide.heightString(unitStyle: .long))
        .foregroundColor(.blue)
    }
  }
}

struct AccessoryCornerView_Previews: PreviewProvider {
  static var previews: some View {
    AccessoryCornerView(tide: Tide.placeholder())
      .previewContext(WidgetPreviewContext(family: .accessoryCorner))

  }
}
