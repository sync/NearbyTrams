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
    
    class func insertInManagedObjectContext(managedObjectContext: NSManagedObjectContext) -> Route
    {
        return NSEntityDescription.insertNewObjectForEntityForName("Route", inManagedObjectContext: managedObjectContext) as Route
    }
    
    func configureWithDictionaryFromRest(json: NSDictionary) -> Void
    {
        routeNo = json["RouteNo"] as? Int
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
