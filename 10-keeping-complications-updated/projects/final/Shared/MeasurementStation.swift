import Foundation

struct MeasurementStation: Codable, Hashable, Identifiable {
  let id: String
  let name: String
  let state: String

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
  
  static func station(for stationId: MeasurementStation.ID) -> MeasurementStation? {
    return allStations.first { $0.id == stationId }
  }

  static func getCurrentTide(for stationId: MeasurementStation.ID) -> Tide? {
    return station(for: stationId)?.tides().last
  }

  static func tides(for stationId: MeasurementStation.ID) -> [Tide] {
    return station(for: stationId)?.tides() ?? []
  }
}
