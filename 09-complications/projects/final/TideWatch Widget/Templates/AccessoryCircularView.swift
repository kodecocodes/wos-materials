import SwiftUI
import WidgetKit

struct AccessoryCircularView: View {
  @Environment(\.redactionReasons) var redactionReasons
  @Environment(\.showsWidgetLabel) var show

  var tide: Tide

  var body: some View {
    /*
    VStack {
      tide.image()
        .font(.title.bold())

      Text(tide.heightString())
        .font(.headline)
        .foregroundColor(.blue)
    }
    ZStack {
      AccessoryWidgetBackground()
      tide.image()
    }
    .widgetLabel {
      Text(tide.heightString())
    }
     */
    Text(show.description)
  }
}

struct AccessoryCircularView_Previews: PreviewProvider {
  static var previews: some View {
    AccessoryCircularView(tide: Tide.placeholder())
      .previewContext(WidgetPreviewContext(family: .accessoryCircular))
  }
}
