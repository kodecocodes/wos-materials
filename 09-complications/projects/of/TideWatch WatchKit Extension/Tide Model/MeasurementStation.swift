import Foundation

struct MeasurementStation: Codable, Hashable, Identifiable {
  let id: Int
  let name: String
  let state: String

  static func forPreview() -> Self {
    .init(id: 1234, name: "Clearwater Beach", state: "FL")
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
}
