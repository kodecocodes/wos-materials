import WidgetKit
import SwiftUI
import Intents

@main
struct Widget: SwiftUI.Widget {
  let kind: String = "com.yourcompany.TideWatch1"

  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      WidgetEntryView(entry: entry)
    }
    .configurationDisplayName("TideWatch1")
    .description("See tide conditions.")
    .supportedFamilies([.accessoryCircular, .accessoryCorner, .accessoryInline, .accessoryRectangular])
    .onBackgroundURLSessionEvents { identifier in
      return SessionCache.shared.isValid(for: identifier)
    } _: { identifier, completion in
      let data = SessionCache.shared.sessionData(for: identifier)
      data.sessionCompletion = completion
    }
  }
}

struct Widget_Previews: PreviewProvider {
  static var previews: some View {
    WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), tide: Tide.placeholder()))
      .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
  }
}
