//
//  LocalDataManagerCoreData.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 09/04/2021.
//

import Foundation
import CoreData

typealias ChangeClosure = ([Change]) -> Void

class LocalDataManagerCoreData: NSObject, LocalDataManager  {
    
    
    
    var fetchedResultsController:  NSFetchedResultsController<NSFetchRequestResult>?
    var changeOnObject: ChangeClosure = { _ in }
    var changes: [Change] = []
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MVVMCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var managedObjectModel: NSManagedObjectModel {
        return persistentContainer.managedObjectModel
    }
    
    override init() {
        super.init()
    }
    
    func startListeningChangesOnUsers(objectChanged: @escaping ChangeClosure) {
        
        /* Save the clousure to call later */
        
        self.changeOnObject = objectChanged
                
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCoreData")
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 20
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        self.fetchedResultsController = fetchedResultsController
        
        do {
            try self.fetchedResultsController?.performFetch()
        } catch {
            print("Error while trying to perform a user fetch.")
        }
    }
    
    func startListeningChangesOnTasks(user: User, objectChanged: @escaping ChangeClosure) {
        
        guard let identifier = user.identifier else {return}
        guard let userCoreData = getManagedObjectFromString(uriRepresentation: identifier) else {return}
        
        self.changeOnObject = objectChanged
                
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskCoreData")
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 20
        request.predicate = NSPredicate(format: "user == %@", userCoreData)
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        self.fetchedResultsController = fetchedResultsController
        
        do {
            try self.fetchedResultsController?.performFetch()
        } catch {
            print("Error while trying to perform a tasks fetch.")
        }
        
    }
    
    func deleteAllObjects() {
        
        guard let fetchedObjects = fetchedResultsController?.fetchedObjects else {return}
        
        for item in fetchedObjects.reversed() {
            if let user = item as? UserCoreData {
                persistentContainer.viewContext.delete(user)
            }
        }
        
    }
    
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        var users: [User] = []
        
        do {
            let fetchRequest = NSFetchRequest<UserCoreData>(entityName: "UserCoreData")
            let userCreatedAtSortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
            fetchRequest.sortDescriptors = [userCreatedAtSortDescriptor]
            let usersCoreData = try viewContext.fetch(fetchRequest)
            for userCoreData in usersCoreData {
                let user = User(name: userCoreData.name ?? "", createdAt: userCoreData.createdAt ?? Date(), identifier: userCoreData.objectID.uriRepresentation().absoluteString)
                users.append(user)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        completion(users)
        
    }
    
    func fetchTasks(user: User, completion: @escaping ([Task]) -> Void) {
        
        guard let identifier = user.identifier else {return}
        guard let userCoreData = getManagedObjectFromString(uriRepresentation: identifier) else {return}
        
        var tasks: [Task] = []
        
        do {
            let fetchRequest = NSFetchRequest<TaskCoreData>(entityName: "TaskCoreData")
            let taskCreatedAtSortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
            fetchRequest.sortDescriptors = [taskCreatedAtSortDescriptor]
            fetchRequest.predicate = NSPredicate(format: "user == %@", userCoreData)
            let tasksCoreData = try viewContext.fetch(fetchRequest)
            for taskCoreData in tasksCoreData {
                let task = Task(title: taskCoreData.title ?? "", createdAt: taskCoreData.createdAt ?? Date(), identifier: taskCoreData.objectID.uriRepresentation().absoluteString)
                tasks.append(task)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        completion(tasks)
        
    }
    
    func deleteUser(at indexPath: IndexPath) {
        guard let userCoreData = fetchedResultsController?.object(at: indexPath) as? UserCoreData else {
            fatalError("Error fetching user")
        }
        
        persistentContainer.viewContext.delete(userCoreData)
        
        do {
            try viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            fatalError("could not delete a user. \(error.localizedDescription)")
        }
        
    }
    
    func deleteTask(at indexPath: IndexPath) {
        guard let taskCoreData = fetchedResultsController?.object(at: indexPath) as? TaskCoreData else {
            fatalError("Error deleting task")
        }
        
        persistentContainer.viewContext.delete(taskCoreData)
        
        do {
            try viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            fatalError("could not delete a task. \(error.localizedDescription)")
        }
        
    }
    
    func addUser(name: String, createdAt: Date, completion: @escaping (User) -> Void) {
    
        let maxOrder = getMaxOrderFromEntity(entityName: "UserCoreData")
        
        guard let userCoreData = UserCoreData.createUser(createdAt: createdAt, name: name, order: (maxOrder ?? 0)+1, in: viewContext) else { return }
        
        let user = User(name: userCoreData.name ?? "Name", createdAt: userCoreData.createdAt ?? Date(), identifier: userCoreData.objectID.uriRepresentation().absoluteString)
        
        completion(user)
        
    }
    
    
    
    func addTask(title: String, user: User, createdAt: Date, completion: @escaping (Task) -> Void) {

        guard let userIdentifier = user.identifier else {return}
        guard let userCoreData = getManagedObjectFromString(uriRepresentation: userIdentifier) as? UserCoreData else {return}
                
        guard let taskCoreData = TaskCoreData.createTask(createdAt: createdAt, user: userCoreData, title: title, in: viewContext) else { return }
        
        let task = Task(title: taskCoreData.title ?? "Task", createdAt: taskCoreData.createdAt ?? Date(), identifier: taskCoreData.objectID.uriRepresentation().absoluteString)
        
        completion(task)
    }
    
    func getManagedObjectFromString(uriRepresentation: String) -> NSManagedObject? {
        
        var objectCoreData: NSManagedObject?
        
        if let objectIDURL = URL(string: uriRepresentation) {
            if let objectCoreDataId = persistentContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: objectIDURL) {
                objectCoreData = viewContext.object(with: objectCoreDataId)
            }
        }
        
        return objectCoreData
    }
    
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func performInBackground(_ block: @escaping (NSManagedObjectContext) -> Void) {
        //Creating our private managedobjectcontext
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        //set viewcontext
        privateMOC.parent = viewContext
        
        //run the block inside privateMOC.
        privateMOC.perform {
            block(privateMOC)
        }
    }
    
    func createDummyContent() {
        
        performInBackground {  (managedObjectContext) in
            
            //users
            guard let user1 = UserCoreData.createUser(createdAt: Date(), name: "Osvaldo Chaparro Bolaños", order: 3, in: managedObjectContext) else {return}
            guard let user2 = UserCoreData.createUser(createdAt: Date(), name: "Jane Doe", order: 2, in: managedObjectContext) else {return}
            guard let user3 = UserCoreData.createUser(createdAt: Date(), name: "John Doe", order: 1, in: managedObjectContext) else {return}
            
            //tasks
            TaskCoreData.createTask(createdAt: Date(), user: user1, title: "task 1", in: managedObjectContext)
            TaskCoreData.createTask(createdAt: Date(), user: user1, title: "task 2", in: managedObjectContext)
            TaskCoreData.createTask(createdAt: Date(), user: user1, title: "task 3", in: managedObjectContext)
            
            TaskCoreData.createTask(createdAt: Date(), user: user2, title: "task 1", in: managedObjectContext)
            TaskCoreData.createTask(createdAt: Date(), user: user2, title: "task 2", in: managedObjectContext)
            TaskCoreData.createTask(createdAt: Date(), user: user2, title: "task 3", in: managedObjectContext)
            
            TaskCoreData.createTask(createdAt: Date(), user: user3, title: "task 1", in: managedObjectContext)
            TaskCoreData.createTask(createdAt: Date(), user: user3, title: "task 2", in: managedObjectContext)
            TaskCoreData.createTask(createdAt: Date(), user: user3, title: "task 3", in: managedObjectContext)
            
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("could not dummy content.")
            }
             
        }
    }
    
    private func getMaxOrderFromEntity(entityName: String) -> Int16? {
        
        saveContext()
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        request.entity = NSEntityDescription.entity(forEntityName: entityName, in: viewContext)
        request.resultType = NSFetchRequestResultType.dictionaryResultType
        
        let keyPathExpression = NSExpression(forKeyPath: "order")
        let maxExpression = NSExpression(forFunction: "max:", arguments: [keyPathExpression])
        let key = "maxOrder"
        
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = key
        expressionDescription.expression = maxExpression
        expressionDescription.expressionResultType = .integer16AttributeType
        
        request.propertiesToFetch = [expressionDescription]
        
        var maxOrder: Int16? = nil
        
        do {
            if let result = try viewContext.fetch(request) as? [[String: Int16]], let dict = result.first {
                maxOrder = dict[key]
            }
        } catch {
            print("Failed to fetch max order with error = \(error)")
            return nil
        }
        
        return maxOrder
    }
}

extension LocalDataManagerCoreData: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        changes = []
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        changeOnObject(changes)
        
        
        changes = []
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type, indexPath, newIndexPath) {
        
            case (.insert, _, let newIndexPath?):
                
                // get the entityname from the modified object to know what to do. It can be User or Task
                let mo = anObject as? NSManagedObject
                let entityName = mo?.entity.name
                
                switch entityName {
                    case "TaskCoreData":
                        let task: Task = .init(title: (anObject as? TaskCoreData)?.title ?? "No title", createdAt: (anObject as? TaskCoreData)?.createdAt ?? Date() , identifier: (anObject as? TaskCoreData)?.objectID.uriRepresentation().absoluteString)
                        changes.append(.insert(task, newIndexPath))
                    case "UserCoreData":
                        let user: User = .init(name: (anObject as? UserCoreData)?.name ?? "No name", createdAt: (anObject as? UserCoreData)?.createdAt ?? Date(), identifier: (anObject as? UserCoreData)?.objectID.uriRepresentation().absoluteString)
                        changes.append(.insert(user, newIndexPath))
                    default:
                        break
                }
                
                
            case (.delete, let indexPath?, _):
                changes.append(.delete(indexPath))
                
            case (.update, let indexPath?, _):
                let user: User = .init(name: (anObject as? UserCoreData)?.name ?? "No name", createdAt: (anObject as? UserCoreData)?.createdAt ?? Date(), identifier: (anObject as? UserCoreData)?.objectID.uriRepresentation().absoluteString)
                changes.append(.update(user, indexPath))
                
            case (.move, let indexPath?, let newIndexPath?):
                changes.append(.move(indexPath, newIndexPath))
                
            default:
                break
        }
    }
}
