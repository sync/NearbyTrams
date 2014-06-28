//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

class Route: NSManagedObject
{
    @NSManaged var routeNo:  NSNumber? // Why when Int it crashes
    @NSManaged var internalRouteNo: NSNumber? // Why when Int it crashes
    @NSManaged var alphaNumericRouteNo: String?
    @NSManaged var destination: String?
    @NSManaged var isUpDestination: Bool
    @NSManaged var hasLowFloor: Bool
    
    class var entityName: NSString {
        get {
            return "Route"
    }
    }
    
    class var primaryKeyFromRest: NSString {
        get {
            return "RouteNo"
    }
    }
    
    class var primaryKey: NSString {
        get {
            return "routeNo"
    }
    }
    
    class func insertInManagedObjectContext(managedObjectContext: NSManagedObjectContext) -> Route
    {
        return NSEntityDescription.insertNewObjectForEntityForName(self.entityName, inManagedObjectContext: managedObjectContext) as Route
    }
}

extension Route
    {
    func configureWithDictionaryFromRest(json: NSDictionary) -> Void
    {
        routeNo = json[self.dynamicType.primaryKeyFromRest] as? Int
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
    
    class func insertOrUpdatesRouteWithDictionaryFromRest(routeDictionary: NSDictionary, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSManagedObjectID
    {
        var foundRoute: Route?
        if let routeNo = routeDictionary[self.primaryKeyFromRest] as? Int
        {
            let result = fetchOneRouteForPrimaryKey(routeNo, usingManagedObjectContext: managedObjectContext)
            foundRoute = result.route
        }
        
        var route = (foundRoute) ? foundRoute! : insertInManagedObjectContext(managedObjectContext)
        route.configureWithDictionaryFromRest(routeDictionary as NSDictionary)
        managedObjectContext.obtainPermanentIDsForObjects([route], error: nil)
        
        return route.objectID
    }
    
    class func insertOrUpdatesRoutesFromRestArray(array: NSDictionary[], inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSManagedObjectID[]
    {
        let objectIds = array.map {
            routeDictionary -> NSManagedObjectID in
            
            return self.insertOrUpdatesRouteWithDictionaryFromRest(routeDictionary, inManagedObjectContext: managedObjectContext)
        }
        
        return objectIds
    }
}

extension Route
    {
    class func fetchOneRouteForPrimaryKey(primaryKey: AnyObject, usingManagedObjectContext managedObjectContext: NSManagedObjectContext) -> (route: Route?, error:NSError?)
    {
        let predicate = NSPredicate(format:"%K == %@", argumentArray: [self.primaryKey, primaryKey])        
        let request = NSFetchRequest(entityName: self.entityName)
        request.predicate = predicate
        request.fetchLimit = 1
        
        var error: NSError?
        let routes = managedObjectContext.executeFetchRequest(request, error: &error)
        
        var route: Route?
        if routes.count > 0
        {
            assert(routes.count == 1, "we sould not have duplicates routes for the same routeNo")
            route = routes[0] as? Route
        }
        
        return (route, error)
    }
    
    class func fetchAllRoutesForManagedObjectIds(managedObjectIds: NSManagedObjectID[], usingManagedObjectContext managedObjectContext: NSManagedObjectContext) -> (routes: Route[]?, error:NSError?)
    {
        let predicate = NSPredicate(format:"self IN %@", managedObjectIds)
        let request = NSFetchRequest(entityName: self.entityName)
        request.predicate = predicate
        
        var error: NSError?
        let foundRoutes = managedObjectContext.executeFetchRequest(request, error: &error) as? Route[]
        
        return (foundRoutes, error)
    }
}
