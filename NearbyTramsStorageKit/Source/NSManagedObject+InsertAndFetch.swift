//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import CoreData

protocol InsertAndFetchManagedObject {
    class var entityName: String { get }
    class var primaryKey: String { get }
    class func insertInManagedObjectContext<T where T: NSManagedObject, T: InsertAndFetchManagedObject>(managedObjectContext: NSManagedObjectContext) -> T
    class func fetchOneForPrimaryKeyValue<T where T: NSManagedObject, T: InsertAndFetchManagedObject>(primaryKey: AnyObject, usingManagedObjectContext managedObjectContext: NSManagedObjectContext) -> (T?, NSError?)
    class func fetchAllForManagedObjectIds<T where T: NSManagedObject, T: InsertAndFetchManagedObject>(managedObjectIds: [NSManagedObjectID], usingManagedObjectContext managedObjectContext: NSManagedObjectContext) -> ([T]?, NSError?)
}

extension NSManagedObject
    {
    class func insertInManagedObjectContext<T where T: NSManagedObject, T: InsertAndFetchManagedObject>(managedObjectContext: NSManagedObjectContext) -> T
    {
        return NSEntityDescription.insertNewObjectForEntityForName(T.entityName, inManagedObjectContext: managedObjectContext) as T
    }
    
    class func fetchOneForPrimaryKeyValue<T where T: NSManagedObject, T: InsertAndFetchManagedObject>(primaryKeyValue: AnyObject, usingManagedObjectContext managedObjectContext: NSManagedObjectContext) -> (T?, NSError?)
    {
        let predicate = NSPredicate(format:"%K == %@", argumentArray: [T.primaryKey, primaryKeyValue])        
        let request = NSFetchRequest(entityName: T.entityName)
        request.predicate = predicate
        request.fetchLimit = 1
        
        var error: NSError?
        let managedObjects = managedObjectContext.executeFetchRequest(request, error: &error)
        
        var managedObject: T?
        if managedObjects.count > 0
        {
            assert(managedObjects.count == 1, "we sould not have duplicates managed objects for the same primary key")
            managedObject = managedObjects[0] as? T
        }
        
        return (managedObject, error)
    }
    
    class func fetchAllForManagedObjectIds<T where T: NSManagedObject, T: InsertAndFetchManagedObject>(managedObjectIds: [NSManagedObjectID], usingManagedObjectContext managedObjectContext: NSManagedObjectContext) -> ([T]?, NSError?)
    {
        let predicate = NSPredicate(format:"self IN %@", managedObjectIds)
        let request = NSFetchRequest(entityName: T.entityName)
        request.predicate = predicate
        
        var error: NSError?
        let foundManagedObjects = managedObjectContext.executeFetchRequest(request, error: &error) as? [T]
        
        return (foundManagedObjects, error)
    }
}
