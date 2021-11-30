import Foundation
import HealthKit

final class HealthStore {
  static let shared = HealthStore()

  private var healthStore: HKHealthStore?
  private var preferredWaterUnit = HKUnit.fluidOunceUS()
  private let brushingCategoryType = HKCategoryType.categoryType(
    forIdentifier: .toothbrushingEvent
  )!
  private let waterQuantityType = HKQuantityType.quantityType(
    forIdentifier: .dietaryWater
  )!
  private let bodyMassType = HKQuantityType.quantityType(
    forIdentifier: .bodyMass
  )!

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

      guard let types = try? await healthStore!.preferredUnits(
        for: [waterQuantityType]
      ) else {
        return
      }

      preferredWaterUnit = types[waterQuantityType]!

      await MainActor.run {
        NotificationCenter.default.post(
          name: .healthStoreLoaded,
          object: nil
        )
      }
    }
  }

  private func save(_ sample: HKSample) async throws {
    guard let healthStore = healthStore else {
      throw HKError(.errorHealthDataUnavailable)
    }

    let _: Bool = try await withCheckedThrowingContinuation {
      continuation in
      healthStore.save(sample) { _, error in
        if let error = error {
          continuation.resume(throwing: error)
          return
        }

        continuation.resume(returning: true)
      }
    }
  }

  // MARK: - Brushing
  func logBrushing(startDate: Date) async throws {
    let status = healthStore?.authorizationStatus(
      for: brushingCategoryType
    )

    guard status == .sharingAuthorized else {
      return
    }

    let sample = HKCategorySample(
      type: brushingCategoryType,
      value: HKCategoryValue.notApplicable.rawValue,
      start: startDate,
      end: Date.now
    )

    try await save(sample)
  }

  // MARK: - Water
  var isWaterEnabled: Bool {
    let status = healthStore?.authorizationStatus(
      for: waterQuantityType
    )

    return status == .sharingAuthorized
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

    try await save(sample)
  }

  private func currentBodyMass() async throws -> Double? {
    guard let healthStore = healthStore else {
      throw HKError(.errorHealthDataUnavailable)
    }

    let sort = NSSortDescriptor(
      key: HKSampleSortIdentifierStartDate,
      ascending: false
    )

    return try await withCheckedThrowingContinuation { continuation in
      let query = HKSampleQuery(
        sampleType: bodyMassType,
        predicate: nil,
        limit: 1,
        sortDescriptors: [sort]
      ) { _, samples, _ in
        guard let latest = samples?.first as? HKQuantitySample else {
          continuation.resume(returning: nil)
          return
        }

        let pounds = latest.quantity.doubleValue(for: .pound())
        continuation.resume(returning: pounds)
      }

      healthStore.execute(query)
    }
  }

  private func drankToday() async throws -> (ounces: Double, amount: Measurement<UnitVolume>) {
    guard let healthStore = healthStore else {
      throw HKError(.errorHealthDataUnavailable)
    }

    let start = Calendar.current.startOfDay(for: Date.now)

    let predicate = HKQuery.predicateForSamples(
      withStart: start,
      end: Date.now,
      options: .strictStartDate
    )

    return await withCheckedContinuation { continuation in
      let query = HKStatisticsQuery(
        quantityType: waterQuantityType,
        quantitySamplePredicate: predicate,
        options: .cumulativeSum
      ) { _, statistics, _ in
        guard let quantity = statistics?.sumQuantity() else {
          continuation.resume(
            returning: (0, .init(value: 0, unit: .liters))
          )
          return
        }

        let ounces = quantity.doubleValue(for: .fluidOunceUS())
        let liters = quantity.doubleValue(for: .liter())

        continuation.resume(
          returning: (ounces, .init(value: liters, unit: .liters))
        )
      }

      healthStore.execute(query)
    }
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

  func waterConsumptionGraphData(
    completion: @escaping ([WaterGraphData]?) -> Void
  ) throws {
    guard let healthStore = healthStore else {
      throw HKError(.errorHealthDataUnavailable)
    }

    var start = Calendar.current.date(
      byAdding: .day, value: -6, to: Date.now
    )!
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

  func updateGraph(
    start: Date,
    results: HKStatisticsCollection?,
    completion: @escaping ([WaterGraphData]?) -> Void
  ) {
    guard let results = results else {
      return
    }

    var statsForDay: [Date: WaterGraphData] = [:]

    for i in 0 ... 6 {
      let day = Calendar.current.date(
        byAdding: .day, value: i, to: start
      )!
      statsForDay[day] = WaterGraphData(for: day)
    }

    results.enumerateStatistics(from: start, to: Date.now) {
      statistic, _ in
      var value = 0.0
      if let sum = statistic.sumQuantity() {
        value = sum
          .doubleValue(for: self.preferredWaterUnit)
          .rounded(.up)
      }

      statsForDay[statistic.startDate]?.value = value
    }

    let statistics = statsForDay
      .sorted { $0.key < $1.key }
      .map { $0.value }

    completion(statistics)
  }
}
