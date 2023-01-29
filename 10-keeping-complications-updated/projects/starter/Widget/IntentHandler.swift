import Intents

final class IntentHandler: INExtension, ConfigurationIntentHandling {
  func provideStationOptionsCollection(for intent: ConfigurationIntent) async throws -> INObjectCollection<StationChoice> {
    let choices = MeasurementStation.allStations.map { station in
      let choice = StationChoice(
        identifier: "\(station.id)",
        display: "\(station.name) in \(station.state)"
      )

      return choice
    }

    return INObjectCollection(items: choices)
  }
}
