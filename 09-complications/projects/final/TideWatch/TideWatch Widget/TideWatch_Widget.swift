import WidgetKit
import SwiftUI
import Intents

// TODO: Only use font sizes headline, body, caption, title.
// headline and body on rectangular, caption and title on circular.
// TODO: For accessoryInline, use ViewThatFits with children.

// TODO: privacy....isLuminanceReduced for "locked"

// TODO: widgetURL() as a modifier on the VStack or whatever the "root" item is.

/*
 isLuminanceReduced is for when it's in always active. Remove time sensitive data.

 If you mark a view .privacySensitive() then only those parts will be redacted in privacy mode.
 */

@main
struct TideWatch_Widget: Widget {
  let kind: String = "com.yourcompany.TideWatch"
  
  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      TideWatch_WidgetEntryView(entry: entry)
    }
    .configurationDisplayName("TideWatch")
    .description("Show the current tide conditions.")
    .supportedFamilies([.accessoryCircular, .accessoryCorner, .accessoryInline, .accessoryRectangular])
  }
}

struct TideWatch_Widget_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      TideWatch_WidgetEntryView(entry: SimpleEntry(date: Date(), tide: Tide.placeholder(), configuration: ConfigurationIntent()))
        .previewDisplayName("Accessory Circular")
        .previewContext(WidgetPreviewContext(family: .accessoryCircular))

      TideWatch_WidgetEntryView(entry: SimpleEntry(date: Date(), tide: Tide.placeholder(), configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .accessoryCorner))
        .previewDisplayName("Accessory Corner")

      TideWatch_WidgetEntryView(entry: SimpleEntry(date: Date(), tide: Tide.placeholder(), configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .accessoryInline))
        .previewDisplayName("Accessory Inline")

      TideWatch_WidgetEntryView(entry: SimpleEntry(date: Date(), tide: Tide.placeholder(), configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
        .previewDisplayName("Accessory Rectangular")
    }
  }
}
