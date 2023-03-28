import Foundation

struct MeasurementStation: Codable, Hashable, Identifiable {
  let id: String
  let name: String
  let state: String

  static let allStations: [Self] = {
    let decoder = JSONDecoder()

    guard
      let plist = Bundle.main.url(forResource: "Stations", withExtension: "json"),
      let data = try? Data(contentsOf: plist),
      let stations = try? decoder.decode([Self].self, from: data)
    else {
      fatalError("Where's the Stations.json file?")
    }

    return stations
  }()

  func tides() -> [Tide] {
    guard let data = UserDefaults.standard.data(forKey: id) else {
      return []
    }

    let decoder = JSONDecoder()
    guard var tides = try? decoder.decode([Tide].self, from: data) else {
      return []
    }

    if let index = tides.lastIndex(where: { $0.date < Date.now }) {
      tides.removeSubrange(0 ..< index)
      UserDefaults.standard.set(tides, forKey: id)
    }

    return tides
  }

  func getCurrentTide(for stationId: MeasurementStation.ID) -> Tide? {
    tides().last
  }

  func store(_ tides: [Tide]) {
    let encoder = JSONEncoder()
    guard let data = try? encoder.encode(tides) else {
      return
    }

    UserDefaults.standard.set(data, forKey: id)
  }

  static func forPreview() -> Self {
    .init(id: "1234", name: "Clearwater Beach", state: "FL")
  }

  static func getCurrentTide(for stationId: Self.ID) -> Tide? {
    return getTides(for: stationId).first
  }

  static func getTides(for stationId: Self.ID) -> [Tide] {
    let station = Self(id: stationId, name: "", state: "")
    return station.tides()
  }

  static func station(for stationId: Self.ID) -> Self? {
    return allStations.first { $0.id == stationId }
  }
}
