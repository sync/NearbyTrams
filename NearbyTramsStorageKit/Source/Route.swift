//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import CoreData

protocol RestAPIManagedObject {
    class func primaryKeyFromRest() -> String
    class func insertOrUpdateRouteWithDictionaryFromRest(routeDictionary: NSDictionary, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSManagedObjectID
    class func insertOrUpdateRoutesFromRestArray(array: NSDictionary[], inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSManagedObjectID[]
    func configureWithDictionaryFromRest(json: NSDictionary) -> Void
}

class Route: NSManagedObject, InsertAndFetchManagedObject, RestAPIManagedObject
{
    @NSManaged var routeNo:  NSNumber? // Why when Int it crashes
    @NSManaged var internalRouteNo: NSNumber? // Why when Int it crashes
    @NSManaged var alphaNumericRouteNo: String?
    @NSManaged var destination: String?
    @NSManaged var isUpDestination: Bool
    @NSManaged var hasLowFloor: Bool
    
    class var entityName: String {
        get {
            return "Route"
    }
    }
    
    class var primaryKey: String {
        get {
            return "routeNo"
    }
    }
}

extension Route
    {
    class func primaryKeyFromRest() -> String
    {
        return "RouteNo"
    }
    
    func configureWithDictionaryFromRest(json: NSDictionary) -> Void
    {
        routeNo = json[self.dynamicType.primaryKeyFromRest()] as? Int
        internalRouteNo = json["InternalRouteNo"] as? Int
        alphaNumericRouteNo = json["AlphaNumericRouteNo"] as? String
        destination = json["Destination"] as? String
        
        if let tmp =  json["IsUpDestination"] as? Bool
        {
            isUpDestination = tmp
        }
        
        if let tmp =  json["HasLowFloor"] as? Bool
        {
            hasLowFloor = tmp
        }
    }
    
    class func insertOrUpdateRouteWithDictionaryFromRest(routeDictionary: NSDictionary, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSManagedObjectID
    {
        var foundRoute: Route?
        if let routeNo = routeDictionary[self.primaryKeyFromRest()] as? Int
        {
            let result: (route: Route?, error:NSError?) = fetchOneForPrimaryKey(routeNo, usingManagedObjectContext: managedObjectContext)
            foundRoute = result.route
        }
        
        var route: Route
        if foundRoute
        {
            route = foundRoute!
        }
        else
        {
            route = insertInManagedObjectContext(managedObjectContext) as Route
        }
        
        route.configureWithDictionaryFromRest(routeDictionary as NSDictionary)
        managedObjectContext.obtainPermanentIDsForObjects([route], error: nil)
        
        return route.objectID
    }
    
    class func insertOrUpdateRoutesFromRestArray(array: NSDictionary[], inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSManagedObjectID[]
    {
        let objectIds = array.map {
            routeDictionary -> NSManagedObjectID in
            
            let objectId: NSManagedObjectID = self.insertOrUpdateRouteWithDictionaryFromRest(routeDictionary, inManagedObjectContext: managedObjectContext)
            return objectId
        }
        
        return objectIds
    }
}
