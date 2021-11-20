import CoreData

final class PersistenceController {
  static let shared = PersistenceController()

  let container: NSPersistentContainer

  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "TideWatch")

    if inMemory {
      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    }

    container.loadPersistentStores { _, error in
      self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
  }
}
