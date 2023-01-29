import WidgetKit
import Intents

struct Provider: IntentTimelineProvider {
  var session: URLSession = {
    let session = URLSession(configuration: URLSessionConfiguration.background(withIdentifier: ""))
    return session
  }()

  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry.placeholder(configuration: ConfigurationIntent())
  }

  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    completion(SimpleEntry.placeholder(configuration: configuration))
  }

  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
    let stationId = configuration.station!.identifier!
    let sessionData = SessionCache.shared.sessionData(for: stationId)

    let two = Calendar.current.date(byAdding: .minute, value: 5, to: Date.now)!
    let tide = Tide(on: Date.now, at: 2)
    completion(.init(entries: [.init(date: Date.now, configuration: configuration, tide: tide)], policy: .after( two)))
return

    sessionData.downloadCompletion = { tides in
      let entries = tides.map { tide in
        SimpleEntry(date: tide.date, configuration: configuration, tide: tide)
      }

      let oneHour = Calendar.current.date(byAdding: .hour, value: 1, to: Date.now)!
      completion(.init(entries: entries, policy: .after(oneHour)))
    }

    CoOpsApi.shared.getWidgetData(for: stationId, using: session)
  }

  func recommendations() -> [IntentRecommendation<ConfigurationIntent>] {
    return MeasurementStation
      .allStations
      .map { station in
        let intent = ConfigurationIntent()
        intent.station = StationChoice(identifier: station.id, display: station.name)

        return IntentRecommendation(intent: intent, description: station.name)
      }
  }
}
