//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import CoreData

protocol RESTManagedObject: InsertAndFetchManagedObject {
    class var primaryKeyFromRest: String { get }
    class func insertOrUpdateWithDictionaryFromRest<T where T: NSManagedObject, T: RESTManagedObject>(dictionary: NSDictionary, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> (T?, NSError?)
    class func insertOrUpdateFromRestArray<T where T: NSManagedObject, T: RESTManagedObject>(array: NSDictionary[], inManagedObjectContext managedObjectContext: NSManagedObjectContext)  -> (T?[], NSError?[])
    mutating func configureWithDictionaryFromRest(json: NSDictionary) -> Void
}

extension NSManagedObject
    {
    class func insertOrUpdateWithDictionaryFromRest<T where T: NSManagedObject, T: RESTManagedObject>(dictionary: NSDictionary, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> (T?, NSError?)
    {
        var foundManagedObject: T?
        if let primaryKeyValue : AnyObject = dictionary[T.primaryKeyFromRest]
        {
            let result: (managedObject: T?, error: NSError?) = fetchOneForPrimaryKey(primaryKeyValue, usingManagedObjectContext: managedObjectContext)
            foundManagedObject = result.managedObject
        }
        else
        {
            // FIXME: build a decent error here
            let error = NSError()
            return (nil, error)
        }
        
        var managedObject: T
        if foundManagedObject
        {
            managedObject = foundManagedObject!
        }
        else
        {
            managedObject = insertInManagedObjectContext(managedObjectContext) as T
        }
        
        managedObject.configureWithDictionaryFromRest(dictionary as NSDictionary)
        managedObjectContext.obtainPermanentIDsForObjects([managedObject], error: nil)
        
        return (managedObject, nil)
    }
    
    class func insertOrUpdateFromRestArray<T where T: NSManagedObject, T: RESTManagedObject>(array: NSDictionary[], inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> (T?[], NSError?[])
    {
        var managedObjects: T?[] = []
        var errors: NSError?[] = []
        for dictionary in array
        {
            let result = self.insertOrUpdateWithDictionaryFromRest(dictionary, inManagedObjectContext: managedObjectContext) as (managedObject: T?, error: NSError?)
            managedObjects.append(result.managedObject)
            errors.append(result.error)
        }
        
        return (managedObjects, errors)
    }
}
