import Foundation

final class CoOpsApi {
  static let shared = CoOpsApi()
  static let numberOfHoursForAverage = 48
  static let stationIdKey = "station"
  private let rootUrl = "https://api.tidesandcurrents.noaa.gov/api/prod/datagetter"

  var station: MeasurementStation? {
    get {
      guard let data = UserDefaults.standard.data(forKey: Self.stationIdKey) else {
        return nil
      }

      let decoder = JSONDecoder()
      guard let station = try? decoder.decode(MeasurementStation.self, from: data) else {
        return nil
      }

      return station
    }
    set {
      if let newValue {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(newValue) else {
          return
        }

        UserDefaults.standard.set(data, forKey: Self.stationIdKey)
      } else {
        UserDefaults.standard.removeObject(forKey: Self.stationIdKey)
      }
    }
  }

  lazy var averageHourString: String = {
    let formatter = MeasurementFormatter()
    formatter.unitOptions = .naturalScale
    formatter.unitStyle = .short

    let measurement = Measurement(value: Double(Self.numberOfHoursForAverage), unit: UnitDuration.hours)
    return formatter.string(from: measurement)
  }()

  private init() {
  }

  private func queryItems(for stationId: MeasurementStation.ID, from start: Date, to end: Date) -> [URLQueryItem] {
    return [
      "product": "predictions",
      "units": "metric",
      "time_zone": "gmt",
      "application": "TideWatch",
      "format": "json",
      "datum": "mllw",
      "interval": "h",
      "station": stationId,
      "begin_date": "\(Formatters.predictionInputFormatter.string(from: start))",
      "end_date": "\(Formatters.predictionInputFormatter.string(from: end))"
    ].map { .init(name: $0.key, value: $0.value) }
  }

  private func url(for stationId: MeasurementStation.ID) -> URL? {
    let now = Calendar.utc.utcHour()

    guard
      var components = URLComponents(string: rootUrl),
      let start = Calendar.utc.date(
        byAdding: .hour,
        value: -Self.numberOfHoursForAverage + 1,
        to: now
      ),
      let end = Calendar.utc.date(byAdding: .day, value: 1, to: now)
    else {
      return nil
    }

    components.queryItems = queryItems(for: stationId, from: start, to: end)

    return components.url
  }

  public func decodeTide(_ data: Data?) -> [Tide] {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(Formatters.predictionOutputFormatter)

    guard
      let data,
      let results = try? decoder.decode(TidePredictions.self, from: data),
      let predictions = results.predictions
    else {
      return []
    }

    return predictions.map { predication in
      Tide(on: predication.date, at: predication.height)
    }
  }

  public func getWidgetData(for stationId: MeasurementStation.ID, using session: URLSession) {
    let end = Calendar.utc.date(byAdding: .hour, value: 1, to: Date.now)!

    var components = URLComponents(string: rootUrl)!
    components.queryItems = queryItems(for: stationId, from: Date.now, to: end)

    let request = URLRequest(url: components.url!)
    session
      .downloadTask(with: request)
      .resume()
  }

  func getLowWaterHeights(for measurementStation: MeasurementStation? = nil) async {
    guard
      let station = measurementStation ?? self.station,
      let url = url(for: station.id)
    else {
      return
    }

    do {
      let (data, response) = try await URLSession.shared.data(from: url)

      guard let resp = response as? HTTPURLResponse, resp.statusCode == 200, !data.isEmpty else {
        return
      }

      let levels = decodeTide(data)

      let count = levels.count

      for (i, current) in levels.enumerated() {
        let height = current.height

        if i == 0 {
          if count == 1 {
            current.type = .unknown
          } else {
            current.type = height > levels[i + 1].height ? .falling : .rising
          }
        } else if i == count - 1 {
          current.type = levels[i - 1].height > height ? .falling : .rising
        } else {
          let prevHeight = levels[i - 1].height
          let nextHeight = levels[i + 1].height

          if height > prevHeight && height > nextHeight {
            current.type = .high
          } else if height < prevHeight && height < nextHeight {
            current.type = .low
          } else if height < nextHeight {
            current.type = .rising
          } else {
            current.type = .falling
          }
        }
      }

      station.store(levels)

      let now = Calendar.utc.utcHour()
      let start = Calendar.utc.date(byAdding: .hour, value: -CoOpsApi.numberOfHoursForAverage, to: now)!
      let end = Date.now
      var current: Tide?

      var numForAverage = 0
      var sum = 0.0

      for level in levels {
        let date = level.date

        guard date >= start else { continue }
        guard date <= end else { break }

        if Calendar.utc.isDate(date, equalTo: now, toGranularity: .hour) {
          current = level
        }

        sum += level.height
        numForAverage += 1
      }

      let averageWaterHeight = numForAverage == 0 ?  nil : Measurement(
        value: sum / Double(numForAverage),
        unit: UnitLength.meters
      )

      let userInfo: [CurrentTideKeys: Any?] = [
        .tide: current,
        .average: averageWaterHeight
      ]

      await MainActor.run {
        NotificationCenter.default.post(
          name: .currentTideUpdated,
          object: nil,
          userInfo: userInfo as [CurrentTideKeys : Any]
        )
      }
    } catch {
      print("Network download failed: \(error.localizedDescription)")
    }
  }
}
