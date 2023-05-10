import WidgetKit
import Intents

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationIntent
  let tide: Tide?
}
