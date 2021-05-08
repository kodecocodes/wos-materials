import Foundation
import Combine
import CoreData

final class CoOpsApi: NSObject {
  static let shared = CoOpsApi()
  static let numberOfHoursForAverage = 48

  private static let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(Formatters.predictionOutputFormatter)

    return decoder
  }()

  lazy var averageHourString: String = {
    let formatter = MeasurementFormatter()
    formatter.unitOptions = .naturalScale
    formatter.unitStyle = .short

    let measurement = Measurement(value: Double(Self.numberOfHoursForAverage), unit: UnitDuration.hours)
    return formatter.string(from: measurement)
  }()

  var stationId: MeasurementStation.ID? {
    get {
      let id = UserDefaults.standard.integer(forKey: "stationId")
      return id == 0 ? nil : id
    }
    set {
      if let newValue = newValue {
        UserDefaults.standard.set(newValue, forKey: "stationId")
      }
    }
  }

  private func url() -> URL? {
    let now = Calendar.utc.utcHour()

    guard
      let stationId = stationId,
      var components = URLComponents(string: "https://api.tidesandcurrents.noaa.gov/api/prod/datagetter"),
      let start = Calendar.utc.date(
        byAdding: .hour,
        value: -Self.numberOfHoursForAverage + 1,
        to: now
      ),
      let end = Calendar.utc.date(byAdding: .day, value: 1, to: now)
    else {
      return nil
    }

    components.queryItems = [
      "product": "predictions",
      "units": "metric",
      "time_zone": "gmt",
      "application": "TideWatch",
      "format": "json",
      "datum": "mllw",
      "interval": "h",
      "station": "\(stationId)",
      "begin_date": "\(Formatters.predictionInputFormatter.string(from: start))",
      "end_date": "\(Formatters.predictionInputFormatter.string(from: end))"
    ].map { .init(name: $0.key, value: $0.value) }

    return components.url
  }

  func getLowWaterHeights() async {
    guard
      let stationId = stationId,
      let url = url()
    else {
      return
    }

    do {
      let (data, response) = try await URLSession.shared.data(from: url)

      guard
        let response = response as? HTTPURLResponse,
        response.statusCode == 200, !data.isEmpty
      else {
        return
      }

      let results = try Self.decoder.decode(TidePredictions.self, from: data)

      guard let predictions = results.predictions else {
        if let error = results.error {
          debugPrint(error)
        }

        return
      }

      try await PersistenceController.shared.container.performBackgroundTask { context in
        try Tide.add(predictions: predictions, to: stationId, in: context)
      }
    } catch {
      print("Network download failed: \(error.localizedDescription)")
    }
  }
}
