import SwiftUI
import Combine

@MainActor
final class ContentModel: ObservableObject {
  @Published var averageWaterLevel: String = "--"
  @Published var currentWaterLevel: Tide?
  @Published var station: MeasurementStation

  private var cancellable = Set<AnyCancellable>()
  private let currentTideChanged = NotificationCenter.default.publisher(for: .currentTideUpdated)

  init() {
    if let stationId = CoOpsApi.shared.station?.id,
       let station = MeasurementStation.allStations.first(where: { $0.id == stationId }) {
      self.station = station
    } else {
      station = MeasurementStation.allStations[0]
      CoOpsApi.shared.station = station
    }

    Task { await CoOpsApi.shared.getLowWaterHeights() }

    NotificationCenter
      .default
      .publisher(for: .currentTideUpdated)
      .sink {
        guard let userInfo = $0.userInfo as? [CurrentTideKeys: Any?] else { return }

        self.currentWaterLevel = userInfo[.tide] as? Tide

        if let average = userInfo[.average] as? Measurement<UnitLength> {
          self.averageWaterLevel = Formatters.heightString(from: average)
        } else {
          self.averageWaterLevel = "--"
        }
      }
      .store(in: &cancellable)
  }

  func fetch(newStation: MeasurementStation? = nil) async {
    if let newStation {
      guard station.id != newStation.id else { return }
      station = newStation
      CoOpsApi.shared.station = newStation
    }

    await CoOpsApi.shared.getLowWaterHeights()
  }
}
