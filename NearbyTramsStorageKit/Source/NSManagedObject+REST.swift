//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import CoreData

protocol RESTManagedObject: InsertAndFetchManagedObject {
    class func primaryKeyValueFromRest(dictionary: NSDictionary) -> String?
    class func insertOrUpdateWithDictionaryFromRest<T where T: NSManagedObject, T: RESTManagedObject>(dictionary: NSDictionary, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> (T?, NSError?)
    class func insertOrUpdateFromRestArray<T where T: NSManagedObject, T: RESTManagedObject>(array: [NSDictionary], inManagedObjectContext managedObjectContext: NSManagedObjectContext)  -> ([T?], [NSError?])
    mutating func configureWithDictionaryFromRest(dictionary: NSDictionary) -> Void
}

extension NSManagedObject
    {
    class func insertOrUpdateWithDictionaryFromRest<T where T: NSManagedObject, T: RESTManagedObject>(dictionary: NSDictionary, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> (T?, NSError?)
    {
        var foundManagedObject: T?
        
        let primaryKeyValue : String? = T.primaryKeyValueFromRest(dictionary)
        if primaryKeyValue
        {
            let result: (managedObject: T?, error: NSError?) = fetchOneForPrimaryKeyValue(primaryKeyValue!, usingManagedObjectContext: managedObjectContext)
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
            managedObject.setValue(primaryKeyValue, forKey: T.primaryKey)
            managedObjectContext.obtainPermanentIDsForObjects([managedObject], error: nil)
        }
        
        managedObject.configureWithDictionaryFromRest(dictionary as NSDictionary)
        
        return (managedObject, nil)
    }
    
    class func insertOrUpdateFromRestArray<T where T: NSManagedObject, T: RESTManagedObject>(array: [NSDictionary], inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> ([T?], [NSError?])
    {
        var managedObjects: [T?] = []
        var errors: [NSError?] = []
        for dictionary in array
        {
            let result = self.insertOrUpdateWithDictionaryFromRest(dictionary, inManagedObjectContext: managedObjectContext) as (managedObject: T?, error: NSError?)
            managedObjects.append(result.managedObject)
            errors.append(result.error)
        }
        
        return (managedObjects, errors)
    }
}
