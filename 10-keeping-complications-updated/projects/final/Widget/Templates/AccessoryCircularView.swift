import SwiftUI
import WidgetKit

struct AccessoryCircularView: View {
  var tide: Tide

  var body: some View {
    VStack {
      tide.image().font(.title.bold())

      Text(tide.heightString())
        .font(.headline)
        .foregroundColor(.blue)
        .widgetAccentable()
    }
  }
}

struct AccessoryCircularView_Previews: PreviewProvider {
  static var previews: some View {
    AccessoryCircularView(tide: Tide.placeholder())
      .previewContext(WidgetPreviewContext(family: .accessoryCircular))
  }
}
