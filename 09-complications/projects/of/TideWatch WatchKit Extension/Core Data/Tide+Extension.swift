import Foundation
import CoreData
import ClockKit

extension Tide {
  var type: TideType {
    get {
      guard let rawType = rawType, let type = TideType(rawValue: rawType) else {
        return .unknown
      }

      return type
    }

    set { rawType = newValue.rawValue }
  }

  // The CoreData model says date is not optional. However, the scaffolding
  // that the MOC uses identifies the Swift type as being optional.  This just
  // makes the rest of the app easier as we don't have to bother with optionals.
  var date: Date {
    get { rawDate ?? Date.now }
    set { rawDate = newValue }
  }

  var stationId: Int {
    get { Int(rawStationId) }
    set { rawStationId = Int32(newValue) }
  }

  func heightString(unitStyle: Formatter.UnitStyle = .short) -> String {
    let heightMeters = Measurement(value: height, unit: UnitLength.meters)
    return Formatters.heightString(from: heightMeters, unitStyle: unitStyle)
  }

  func image() -> UIImage {
    let imageName = type == .unknown ? "high" : type.rawValue

    guard let image = UIImage(named: "tide_\(imageName)") else {
      fatalError("Where are the tide type images?")
    }

    return image
  }

  static func getMaximumDate() -> Date? {
    let newest = NSExpressionDescription()
    newest.name = "newest"
    newest.expression = .init(forFunction: "max:", arguments: [NSExpression(forKeyPath: \Tide.rawDate)])
    newest.expressionResultType = .dateAttributeType

    let request = Tide.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
    request.resultType = .dictionaryResultType
    request.propertiesToFetch = [newest]

    let context = PersistenceController.shared.container.viewContext
    guard
      let results = try? context.fetch(request) as? [[String: AnyObject]],
      let max = results.first?[newest.name] as? Date
    else {
      return nil
    }

    return max
  }

  static func getEntries(after date: Date, limit: Int) -> [Tide]? {
    guard let stationId = CoOpsApi.shared.stationId else { return nil }

    let request = Self.fetchRequest(for: stationId, from: date.addingTimeInterval(10), to: .distantFuture)
    request.fetchLimit = limit

    return try? PersistenceController.shared.container.viewContext.fetch(request)
  }

  static func getCurrent() -> Tide? {
    let start = Calendar.utc.utcHour()

    guard
      let stationId = CoOpsApi.shared.stationId,
      let end = Calendar.utc.date(byAdding: .hour, value: 1, to: start)
    else {
      return nil
    }

    let request = Self.fetchRequest(for: stationId, from: start, to: end)
    request.fetchLimit = 1

    return try? PersistenceController.shared.container.viewContext.fetch(request).first
  }

  static func fetchRequest(
    for stationId: MeasurementStation.ID,
    from start: Date,
    to end: Date
  ) -> NSFetchRequest<Tide> {
    let dateKeyPath = #keyPath(Tide.rawDate)
    let request = Tide.fetchRequest() as NSFetchRequest<Tide>
    request.sortDescriptors = [.init(keyPath: \Tide.rawDate, ascending: true)]
    request.predicate = .init(
      format: "%K == %i AND %K >= %@ AND %K < %@",
      argumentArray: [#keyPath(Tide.rawStationId), stationId, dateKeyPath, start, dateKeyPath, end]
    )

    return request
  }

  static func add(
    predictions: [TidePrediction],
    to stationId: MeasurementStation.ID,
    in context: NSManagedObjectContext
  ) throws {
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

    predictions.forEach { prediction in
      let tide = Tide(context: context)
      tide.date = prediction.date
      tide.height = prediction.height
      tide.stationId = stationId
      tide.type = .unknown
    }

    try Self.calculateTideTypes(in: context, for: stationId)
    try context.save()
  }

  private static func calculateTideTypes(in context: NSManagedObjectContext, for stationId: MeasurementStation.ID) throws {
    let request = Tide.fetchRequest() as NSFetchRequest<Tide>
    request.predicate = .init(format: "%K == %i", #keyPath(Tide.rawStationId), stationId)
    request.sortDescriptors = [.init(keyPath: \Tide.rawDate, ascending: true)]

    guard let levels = try? context.fetch(request) else {
      return
    }

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
  }
}
