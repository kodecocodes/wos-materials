import SwiftUI
import Combine
import CoreData

@MainActor
final class ContentModel: ObservableObject {
  @Published var averageWaterLevel: String = "--"
  @Published var currentWaterLevel: Tide?
  @Published var station: MeasurementStation

  private var cancellable = Set<AnyCancellable>()

  init() {
    if let stationId = CoOpsApi.shared.stationId,
      let station = MeasurementStation.allStations.first(where: { $0.id == stationId }) {
      self.station = station
    } else {
      station = MeasurementStation.allStations[0]
      CoOpsApi.shared.stationId = station.id
    }

    Task { await CoOpsApi.shared.getLowWaterHeights() }

    NotificationCenter
      .default
      .publisher(for: .NSManagedObjectContextDidSave)
      .sink { _ in async { await self.calculateAverageAndCurrent() } }
      .store(in: &cancellable)
  }

  func fetch(newStation: MeasurementStation? = nil) async {
    if let newStation = newStation {
      guard station.id != newStation.id else { return }
      station = newStation
      CoOpsApi.shared.stationId = newStation.id
    }

    await CoOpsApi.shared.getLowWaterHeights()
  }

  private func calculateAverageAndCurrent() async {
    let context = PersistenceController.shared.container.viewContext
    await context.perform(schedule: .enqueued) {
      let now = Calendar.utc.utcHour()
      // Remember the predicate will look up to but not including the end date.
      // For this query we really want to include "now" in the search
      let start = Calendar.utc.date(byAdding: .hour, value: -CoOpsApi.numberOfHoursForAverage - 1, to: now)!
      let end = Calendar.utc.date(byAdding: .hour, value: 1, to: now)!
      let request = Tide.fetchRequest(for: self.station.id, from: start, to: end)

      guard
        let levels = try? context.fetch(request),
        let current = levels.first(where: {
          Calendar.utc.isDate($0.date, equalTo: now, toGranularity: .hour)
        }) else {
          return
        }

      let total = levels.reduce(0.0) { $0 + $1.height }
      let averageWaterHeight = Measurement(
        value: total / Double(levels.count),
        unit: UnitLength.meters
      )

      let objectID = current.objectID

      DispatchQueue.main.async {
        self.averageWaterLevel = Formatters.heightString(from: averageWaterHeight)
        self.currentWaterLevel = context.object(with: objectID) as? Tide
      }
    }
  }
}
