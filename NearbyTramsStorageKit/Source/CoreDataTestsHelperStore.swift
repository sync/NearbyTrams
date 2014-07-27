//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import CoreData

public class CoreDataTestsHelperStore
{
    public init() {}
    
    public lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectModel = CoreDataStackManager.sharedInstance.managedObjectModel
        
        var error: NSError? = nil
        let persistentStoreCoordinator:NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        if persistentStoreCoordinator.addPersistentStoreWithType(NSInMemoryStoreType,
            configuration: nil,
            URL: nil,
            options: nil,
            error: &error) == nil
        {
            println("there was an error loading in memory core data tests store: \(error!.localizedDescription)")
            abort()
        }
        
        let _managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        _managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        
        return _managedObjectContext
        }()
}
