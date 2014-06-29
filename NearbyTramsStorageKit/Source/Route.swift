//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import CoreData

class Route: NSManagedObject, InsertAndFetchManagedObject, RESTManagedObject
{
    @NSManaged var routeNo:  NSNumber? // Why when Int it crashes
    @NSManaged var internalRouteNo: NSNumber? // Why when Int it crashes
    @NSManaged var alphaNumericRouteNo: String?
    @NSManaged var destination: String?
    @NSManaged var isUpDestination: Bool
    @NSManaged var hasLowFloor: Bool
    @NSManaged var stops : NSMutableSet
    
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
    
    class var primaryKeyFromRest: String {
        get {
            return "RouteNo"
    }
    }
    
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
}
