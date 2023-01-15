import Foundation
import HealthKit

final class HealthStore {
  static let shared = HealthStore()

  private let brushingCategoryType = HKCategoryType(.toothbrushingEvent)
  private let waterQuantityType = HKQuantityType(.dietaryWater)
  private let bodyMassType = HKQuantityType(.bodyMass)

  private var healthStore: HKHealthStore?
  private var preferredWaterUnit = HKUnit.fluidOunceUS()

  var isWaterEnabled: Bool {
    let status = healthStore?.authorizationStatus(
      for: waterQuantityType
    )

    return status == .sharingAuthorized
  }

  private init() {
    guard HKHealthStore.isHealthDataAvailable() else {
      return
    }

    healthStore = HKHealthStore()

    Task {
      try await healthStore!.requestAuthorization(
        toShare: [brushingCategoryType, waterQuantityType],
        read: [brushingCategoryType, waterQuantityType, bodyMassType]
      )

      if
        let types = try? await healthStore!.preferredUnits(for: [waterQuantityType]),
        let type = types[waterQuantityType]
      {
        preferredWaterUnit = type
      }

      await MainActor.run {
        NotificationCenter.default.post(name: .healthStoreLoaded, object: nil)
      }
    }
  }

  private func currentBodyMass() async throws -> Double? {
    guard let healthStore else {
      throw HKError(.errorHealthDataUnavailable)
    }

    let descriptor = HKSampleQueryDescriptor(
      predicates: [.quantitySample(type: bodyMassType)],
      sortDescriptors: [SortDescriptor(\.startDate, order: .reverse)],
      limit: 1
    )

    let results = try await descriptor.result(for: healthStore)
    return results.first?.quantity.doubleValue(for: .pound())
  }

  func currentWaterStatus() async throws -> (
    Measurement<UnitVolume>, Double?
  ) {
    let (ounces, measurement) = try await drankToday()

    guard let mass = try? await currentBodyMass() else {
      return (measurement, nil)
    }

    let goal = mass / 2.0
    let percentComplete = ounces / goal

    return (measurement, percentComplete)
  }

  private func drankToday() async throws -> (
    ounces: Double,
    amount: Measurement<UnitVolume>
  ) {
    guard let healthStore else {
      throw HKError(.errorHealthDataUnavailable)
    }

    let dateRangePredicate = HKQuery.predicateForSamples(
      withStart: Calendar.current.startOfDay(for: Date.now),
      end: Date.now,
      options: .strictStartDate
    )

    let sumPredicate = HKSamplePredicate.quantitySample(
      type: waterQuantityType,
      predicate: dateRangePredicate
    )

    let descriptor = HKStatisticsQueryDescriptor(predicate: sumPredicate, options: .cumulativeSum)

    guard let quantity = try await descriptor.result(for: healthStore)?.sumQuantity() else {
      return (ounces: 0, amount: .init(value: 0, unit: .liters))
    }

    let ounces = quantity.doubleValue(for: .fluidOunceUS())
    let liters = quantity.doubleValue(for: .liter())

    return (ounces, .init(value: liters, unit: .liters))
  }

  func logBrushing(startDate: Date) async throws {
    guard
      let healthStore,
      healthStore.authorizationStatus(for: brushingCategoryType) == .sharingAuthorized
    else {
      return
    }

    let sample = HKCategorySample(
      type: brushingCategoryType,
      value: HKCategoryValue.notApplicable.rawValue,
      start: startDate,
      end: Date.now
    )

    try await healthStore.save(sample)
  }

  func logWater(quantity: HKQuantity) async throws {
    guard isWaterEnabled else {
      return
    }

    let sample = HKQuantitySample(
      type: waterQuantityType,
      quantity: quantity,
      start: Date.now,
      end: Date.now
    )

    try await healthStore!.save(sample)
  }

  private func updateGraph(
    start: Date,
    results: HKStatisticsCollection?,
    completion: @escaping ([WaterGraphData]?) -> Void
  ) {
    guard let results else {
      return
    }

    var statistics: [WaterGraphData] = []

    results.enumerateStatistics(from: start, to: Date.now) { statistic, _ in
      var value = 0.0

      if let sum = statistic.sumQuantity() {
        value = sum
          .doubleValue(for: self.preferredWaterUnit)
          .rounded(.up)
      }

      statistics.append(.init(value, for: statistic.startDate))
    }

    completion(statistics)
  }

  func waterConsumptionGraphData(
    completion: @escaping ([WaterGraphData]?) -> Void
  ) throws {
    guard let healthStore else {
      throw HKError(.errorHealthDataUnavailable)
    }

    var start = Calendar.current.date(byAdding: .day, value: -6, to: Date.now)!
    start = Calendar.current.startOfDay(for: start)

    let predicate = HKQuery.predicateForSamples(
      withStart: start,
      end: nil,
      options: .strictStartDate
    )

    let query = HKStatisticsCollectionQuery(
      quantityType: waterQuantityType,
      quantitySamplePredicate: predicate,
      options: .cumulativeSum,
      anchorDate: start,
      intervalComponents: .init(day: 1)
    )

    query.initialResultsHandler = { _, results, _ in
      self.updateGraph(start: start, results: results, completion: completion)
   }

    query.statisticsUpdateHandler = { _, _, results, _ in
      self.updateGraph(start: start, results: results, completion: completion)
    }

    healthStore.execute(query)
  }
}
