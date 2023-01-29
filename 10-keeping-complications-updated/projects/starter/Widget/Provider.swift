import WidgetKit
import Intents

struct Provider: IntentTimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry.placeholder(configuration: ConfigurationIntent())
  }

  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    completion(SimpleEntry.placeholder(configuration: configuration))
  }

  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
    let entries = MeasurementStation
      .tides(for: configuration.station!.identifier!)
      .map { SimpleEntry(date: $0.date, configuration: configuration, tide: $0 )}

    let timeline = Timeline(entries: entries, policy: .never)

    completion(timeline)
  }

  func recommendations() -> [IntentRecommendation<ConfigurationIntent>] {
    return [
      IntentRecommendation(intent: ConfigurationIntent(), description: "My Intent Widget")
    ]
  }
}

