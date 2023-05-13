import WidgetKit

struct Provider: IntentTimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: ConfigurationIntent(), tide: Tide.placeholder())
  }

  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), configuration: configuration, tide: Tide.placeholder())
    completion(entry)
  }

  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
    let stationId = configuration.station!.identifier!
    let sessionData = SessionCache.shared.sessionData(for: stationId)

    sessionData.downloadCompletion = { tides in
      var entries = tides.map { tide in
        SimpleEntry(date: tide.date, configuration: configuration, tide: tide)
      }

      if entries.isEmpty {
        entries = [SimpleEntry(date: Date.now, configuration: configuration, tide: nil)]
      }

      let oneHour = Calendar.current.date(byAdding: .hour, value: 1, to: Date.now)!
      completion(.init(entries: entries, policy: .after(oneHour)))
    }

    CoOpsApi.shared.getWidgetData(for: stationId, using: sessionData.session)
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
 
