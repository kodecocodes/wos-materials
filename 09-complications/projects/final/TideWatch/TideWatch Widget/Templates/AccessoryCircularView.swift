import SwiftUI
import WidgetKit

struct AccessoryCircularView: View {
  let tide: Tide

  var body: some View {
    if tide.hasData {
      VStack {
        tide.image()
          .resizable()
          .frame(maxWidth: 31.2, maxHeight: 52)

        Text(tide.heightString())
          .widgetAccentable()
      }
    } else {
      Image(systemName: "water.waves.and.arrow.down")
    }
  }
}

struct AccessoryCircularView_Previews: PreviewProvider {
  static var previews: some View {
    AccessoryCircularView(tide: Tide.placeholder())
      .previewContext(WidgetPreviewContext(family: .accessoryCircular))

    AccessoryCircularView(tide: Tide.noData())
      .previewContext(WidgetPreviewContext(family: .accessoryCircular))
  }
}

