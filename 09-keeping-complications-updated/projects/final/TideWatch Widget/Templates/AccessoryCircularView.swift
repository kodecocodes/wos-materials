import SwiftUI
import WidgetKit

struct AccessoryCircularView: View {
  let tide: Tide?

  var body: some View {
    if let tide {
      VStack {
        tide.image().font(.title.bold())

        Text(tide.heightString())
          .font(.headline)
          .foregroundColor(.blue)
          .widgetAccentable()
      }
    } else {
      Image(systemName: "questionmark.circle")
        .font(.title.bold())
    }
  }
}

struct AccessoryCircularView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      AccessoryCircularView(tide: Tide.placeholder())
        .previewContext(WidgetPreviewContext(family: .accessoryCircular))

      AccessoryCircularView(tide: nil)
        .previewContext(WidgetPreviewContext(family: .accessoryCircular))
    }
  }
}
