import WidgetKit
import Intents

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationIntent
  let tide: Tide

  static func placeholder(configuration: ConfigurationIntent) -> SimpleEntry {
    return .init(date: Date.now, configuration: configuration, tide: Tide.placeholder())
  }
}
