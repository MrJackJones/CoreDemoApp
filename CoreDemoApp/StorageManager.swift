//
//  StorageManager.swift
//  CoreDemoApp
//
//  Created by Ivan on 20.04.2022.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    private init() {
        context = persistentContainer.viewContext
    }
    
    var context: NSManagedObjectContext
    
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDemoApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData() -> [Task] {
        let fetchRequest = Task.fetchRequest()
        var taskList: [Task] = []
        do {
            taskList = try context.fetch(fetchRequest)
        } catch let error {
            print("Failed to fetch data", error)
        }
        return taskList
    }
    
    func add(_ taskName: String) -> Task? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return nil }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return nil }
        task.title = taskName
        saveContext()
        return task
    }
    
    func delete(_ task: Task) {
        context.delete(task)
        saveContext()
    }
    
    func edit(changeTitleOf task: Task, to newTitle: String) {
        task.title = newTitle
        saveContext()
    }
}
