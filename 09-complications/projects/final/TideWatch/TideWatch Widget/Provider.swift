import Foundation
import WidgetKit

// TODO: Migrate: https://developer.apple.com/documentation/widgetkit/converting-a-clockkit-app
// TODO: Network: https://developer.apple.com/documentation/widgetkit/keeping-a-widget-up-to-date


struct Provider: IntentTimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    let tide = Tide.placeholder()

    return .init(date: Date.now, tide: tide, configuration: ConfigurationIntent())
  }

  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    completion(placeholder(in: context))
  }

  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
    var entries = MeasurementStation
      .getTides(for: configuration.station!.identifier!)
      .map { tide in
        SimpleEntry(date: tide.date, tide: tide, configuration: configuration)
      }

    if entries.isEmpty {
      entries = [.init(date: Date.now, tide: Tide.noData(), configuration: configuration)]
    }

    // context.environmentVariants.isLuminanceReduced
    completion(.init(entries: entries, policy: .never))
  }

  func recommendations() -> [IntentRecommendation<ConfigurationIntent>] {
    // TODO: Documentation invalidateConfigurationRecommendations() and https://developer.apple.com/documentation/widgetkit/widgetcenter/invalidateconfigurationrecommendations()

    return MeasurementStation.allStations.map { station in
      let intent = ConfigurationIntent()
      intent.station = StationChoice(
        identifier: station.id,
        display: "\(station.name) in \(station.state)"
      )

      return IntentRecommendation(intent: intent, description: intent.station!.displayString)
    }
  }
}


