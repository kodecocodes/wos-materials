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

    return stations.sorted { $0.name < $1.name }
  }()

  func tides() -> [Tide] {
    guard let data = UserDefaults.extensions.data(forKey: id) else {
      print("Got no tides for \(name)")
      return []
    }

    let decoder = JSONDecoder()
    guard var tides = try? decoder.decode([Tide].self, from: data) else {
      print("Unabled to decode tides for \(name)")
      return []
    }

    if let index = tides.lastIndex(where: { $0.date < Date.now }) {
      tides.removeSubrange(0 ..< index)
      store(tides)
    }

    print("Returning \(tides.count) for \(name)")
    return tides
  }

  func store(_ tides: [Tide]) {
    let encoder = JSONEncoder()
    guard let data = try? encoder.encode(tides) else {
      return
    }

    UserDefaults.extensions.set(data, forKey: id)
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
