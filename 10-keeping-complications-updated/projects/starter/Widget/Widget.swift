import WidgetKit
import SwiftUI
import Intents

@main
struct Widget: SwiftUI.Widget {
  let kind: String = "com.yourcompany.TideWatch"

  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      WidgetEntryView(entry: entry)
    }
    .configurationDisplayName("TideWatch")
    .description("See tide conditions.")
    .supportedFamilies([.accessoryCircular, .accessoryCorner, .accessoryInline, .accessoryRectangular])
     
  }
}

struct Widget_Previews: PreviewProvider {
  static var previews: some View {
    WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), tide: Tide.placeholder()))
      .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
  }
}
