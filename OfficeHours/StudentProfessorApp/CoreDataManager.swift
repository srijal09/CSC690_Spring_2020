//
//  CoreDataManager.swift
//  CoredataTest
//


import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    static let sharedInstance = CoreDataManager()
    
    var managedContext: NSManagedObjectContext?
    
    private override init() {
        super.init()
        
        if let app: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            managedContext = app.persistentContainer.viewContext
        }
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
    }
    
    
    //MARK:- TASK
    
    func saveTaskInDatabase(_ userName: String,  password: String, name : String) {
        let addTaskObj = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedContext!) as! User
        addTaskObj.username = userName
        addTaskObj.password = password
        addTaskObj.name = name
        saveContext()
    }
    
    func saveCodeinDatabase(_ generatedCode: String, byTeacher: String) {
        let codeObj = NSEntityDescription.insertNewObject(forEntityName: "Code", into: managedContext!) as! Code
        codeObj.accesCode = generatedCode
        codeObj.byTeacher = byTeacher
        
        saveContext()
    }
    func saveSlotAppointmenteinDatabase(_ date: String, time: String) {
        let codeObj = NSEntityDescription.insertNewObject(forEntityName: "SlotAppointment", into: managedContext!) as! SlotAppointment
        codeObj.date = date
        codeObj.timeSlot = time
        
        saveContext()
    }
    
    
    func saveAppointmentInDatabase(_ studName: String,  id: String, status : String, time : String,date :String) {
        let addAppointmentObj = NSEntityDescription.insertNewObject(forEntityName: "Appointment", into: managedContext!) as! Appointment
        addAppointmentObj.name = studName
        addAppointmentObj.id = id
        addAppointmentObj.appointmentStatus = status
        addAppointmentObj.time    = time
        addAppointmentObj.dateSlot    = date
        saveContext()
    }
    
    func saveReasonInDatabase(_ id: String,  reason: String) {
        
        let addReasonObj = NSEntityDescription.insertNewObject(forEntityName: "Reason", into: managedContext!) as! Reason
        addReasonObj.reason = reason
        addReasonObj.id = id
        saveContext()
    }
    
    func getReasonFromDatabase() -> [Reason] {
        if let reasonList = CoreDataManager.sharedInstance.fetchEntities(entityName: "Reason", predicate: nil, predicateName: nil) as? [Reason] {
            return reasonList
        }
        return []
    }
    
    
    func getTaskFromDatabase() -> [User] {
        if let userList = CoreDataManager.sharedInstance.fetchEntities(entityName: "User", predicate: nil, predicateName: nil) as? [User] {
            return userList
        }
        return []
    }
    
    func getAcessCodeFromDatabase() -> [Code] {
        if let codeList = CoreDataManager.sharedInstance.fetchEntities(entityName: "Code", predicate: nil, predicateName: nil) as? [Code] {
            return codeList
        }
        return []
    }
    
    func updateTask(_ taskDescription: String, newValue: String, filedName: String,predicateName : String? ) {
        let results = fetchEntities(entityName: "User", predicate: taskDescription, predicateName: predicateName)
        for result in results {
            result.setValue(newValue, forKey: filedName)
            saveContext()
        }
    }
    
    
    //MARK:- save Context
    
    func saveContext() {
        if managedContext == nil {
            return
        }
        do {
            try managedContext!.save()
        } catch {
            print("CoreDataManager === saving failed.\n\n")
        }
    }
    
    func fetchEntities(entityName: String, predicate: String?,predicateName : String? ) -> [NSManagedObject] {
        if managedContext == nil {
            return []
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if predicate != nil && predicate != "" {
            request.predicate = NSPredicate(format: "\(predicateName!) == %@", predicate!)
            
            // request.predicate = NSPredicate(format: "name contains[c] %@", predicate!)
        }
        request.returnsObjectsAsFaults = false
        do {
            return try managedContext!.fetch(request) as! [NSManagedObject]
        } catch {
            print("CoreDataManager === fetching failed.")
        }
        
        return []
    }
    
    func deleteEntity(entityName: String, predicate: String?) {
        let results = fetchEntities(entityName: entityName, predicate: predicate, predicateName: "")
        
        for result in results {
            managedContext!.delete(result)
        }
        print("CoreDataManager === deleting.")
        saveContext()
    }
    
    func updateEntity(entityName: String, predicate: String?,predicateName : String?, metaInfo: [String: Any]) {
        let results = fetchEntities(entityName: entityName, predicate: predicate, predicateName: predicateName)
        for result in results {
            for (key, value) in metaInfo {
                result.setValue(value, forKey: key)
            }
            print("CoreDataManager === updating.")
            saveContext()
        }
    }
    
    
    // MARK: - Core Data Stack
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    public private(set) lazy var mainManagedObjectContext: NSManagedObjectContext = {
        // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.parent = self.privateManagedObjectContext
        
        return managedObjectContext
    }()
    
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // Fetch Model URL
        guard let modelURL = Bundle.main.url(forResource: "DataBaseApp", withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        // Initialize Managed Object Model
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        return NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    }()
    
    // MARK: - Public API
    
    public func saveChanges() {
        mainManagedObjectContext.performAndWait {
            do {
                if self.mainManagedObjectContext.hasChanges {
                    try self.mainManagedObjectContext.save()
                }
            } catch {
                print("Unable to Save Changes of Main Managed Object Context")
                print("\(error), \(error.localizedDescription)")
            }
        }
        
        privateManagedObjectContext.perform {
            do {
                if self.privateManagedObjectContext.hasChanges {
                    try self.privateManagedObjectContext.save()
                }
            } catch {
                print("Unable to Save Changes of Private Managed Object Context")
                print("\(error), \(error.localizedDescription)")
            }
        }
    }
    
    public func privateChildManagedObjectContext() -> NSManagedObjectContext {
        // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.parent = mainManagedObjectContext
        
        return managedObjectContext
    }
    
    
    // MARK: - Helper Methods
    
    private func setupCoreDataStack() {
        // Fetch Persistent Store Coordinator
        guard let persistentStoreCoordinator = mainManagedObjectContext.persistentStoreCoordinator else {
            fatalError("Unable to Set Up Core Data Stack")
        }
        
        DispatchQueue.global().async {
            // Add Persistent Store
            self.addPersistentStore(to: persistentStoreCoordinator)
            
            
        }
    }
    
    private func addPersistentStore(to persistentStoreCoordinator: NSPersistentStoreCoordinator) {
        // Helpers
        let fileManager = FileManager.default
        let storeName = "DataBaseApp.sqlite"
        
        // URL Documents Directory
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // URL Persistent Store
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption : true,
                NSInferMappingModelAutomaticallyOption : true ]
            
            // Add Persistent Store
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: options)
        } catch {
            fatalError("Unable to Add Persistent Store")
        }
    }
    

}
