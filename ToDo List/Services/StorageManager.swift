//
//  StorageManager.swift
//  ToDo List
//
//  Created by Ilyas on 28.11.2024.
//

import Foundation
import CoreData

final class StorageManager {
  static let shared = StorageManager()
  
  // MARK: - Core Data stack
  let persistentContainer: NSPersistentContainer = {

      let container = NSPersistentContainer(name: "ToDo_List")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
          if let error = error as NSError? {

              fatalError("Unresolved error \(error), \(error.userInfo)")
          }
      })
      return container
  }()
  
  private let viewContext: NSManagedObjectContext

  private init() {
    viewContext = persistentContainer.viewContext
  }
  
  // MARK: - CRUD
  func createTask(withID id: Int16,
                  todo: String,
                  fullDescription: String? = nil,
                  creationDate: Date,
                  completed: Bool,
                  completion: (Task) -> Void) {
    let task = Task(context: viewContext)
    task.id = id
    task.todo = todo
    task.fullDescription = fullDescription
    task.creationDate = creationDate
    task.completed = completed
    completion(task)
    saveContext()
  }
  
  // MARK: - Core Data Saving support
  func saveContext () {
      let context = persistentContainer.viewContext
      if context.hasChanges {
          do {
              try context.save()
          } catch {
              let nserror = error as NSError
              fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
          }
      }
  }
}
