//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Олег Дементьев on 26.08.2021.
//

import CoreData
import Foundation

class CoreDataManager {
    
    //Singleton
    static let instance = CoreDataManager()
    private init() {}
    
    // MARK: - Variables
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    // MARK: - Core Data Stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "TaskModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    func entityDescription(forEntity name: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: name, in: self.managedObjectContext)!
    }
    
    // MARK: - Core Data Saving Support
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
        
    // MARK: - Fetched Results Controller
    static func getFetchRequest(forEntity entityName: String,
        descriptors: [(key: String, ascending: Bool)]?,
        predicate: (format: String, arguments: [Any])?
    ) -> NSFetchRequest<NSFetchRequestResult> {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        // Sort Descriptor
        if descriptors != nil {
            var descriptorsArray = [NSSortDescriptor]()
            for descriptor in descriptors! {
                descriptorsArray.append(NSSortDescriptor(key: descriptor.key, ascending: descriptor.ascending))
            }
            fetchRequest.sortDescriptors = descriptorsArray
        }
        // Predicate
        if predicate != nil {
            let predicate = NSPredicate(format: predicate!.format, argumentArray: predicate!.arguments)
            fetchRequest.predicate = predicate
        }
        return fetchRequest
    }
    
    static func getFetchRequest(forEntity entityName: String, descriptors: [NSSortDescriptor]?) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.sortDescriptors = descriptors ?? Array<NSSortDescriptor>()
        return fetchRequest
    }
    
    static func getFetchedResultsController(forFetchRequest fetchRequest: NSFetchRequest<NSFetchRequestResult>) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func tryPerformFetch() {
        do {
            try CoreDataManager.instance.fetchedResultsController?.performFetch()
        } catch {
            print(error)
        }
    }
}
