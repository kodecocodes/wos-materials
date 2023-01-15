import Intents

// Add to reference in documentation https://developer.apple.com/documentation/widgetkit/making-a-configurable-widget
final class IntentHandler: INExtension, ConfigurationIntentHandling {
  func provideStationOptionsCollection(for intent: ConfigurationIntent) async throws -> INObjectCollection<StationChoice> {
    let choices = MeasurementStation.allStations.map { station in
      let choice = StationChoice(
        identifier: station.id,
        display: "\(station.name) in \(station.state)"
      )

      return choice
    }

    return INObjectCollection(items: choices)
  }

  override func handler(for intent: INIntent) -> Any? {
    self
  }
}
