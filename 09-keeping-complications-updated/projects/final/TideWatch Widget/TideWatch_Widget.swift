import WidgetKit
import SwiftUI
import Intents

@main
struct TideWatch_Widget: Widget {
  let kind: String = "TideWatch_Widget"

  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      EntryView(entry: entry)
    }
    .configurationDisplayName("TideWatch")
    .description("Show current tide conditions.")
    .onBackgroundURLSessionEvents { identifier in
      return SessionCache.shared.isValid(for: identifier)
    } _: { identifier, completion in
      let data = SessionCache.shared.sessionData(for: identifier)
      data.sessionCompletion = completion
    }
  }
}

struct TideWatch_Widget_Previews: PreviewProvider {
  static var previews: some View {
    EntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), tide: Tide.placeholder()))
      .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
  }
}
