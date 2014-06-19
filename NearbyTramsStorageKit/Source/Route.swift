//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

class Route: NSManagedObject
{
    @NSManaged var routeNo: NSNumber // Why when Int it crashes
    @NSManaged var internalRouteNo: NSNumber // Why when Int it crashes
    @NSManaged var alphaNumericRouteNo: String
    @NSManaged var destination: String
    @NSManaged var isUpDestination: Bool
    @NSManaged var hasLowFloor: Bool
    
    class func insertInManagedObjectContext(managedObjectContext: NSManagedObjectContext) -> Route
    {
        return NSEntityDescription.insertNewObjectForEntityForName("Route", inManagedObjectContext: managedObjectContext) as Route
    }
    
    func configureWithDictionaryFromRest(json: NSDictionary) -> Void
    {
        if let tmp =  json["RouteNo"] as? Int
        {
            routeNo = tmp
        }
        
        if let tmp =  json["InternalRouteNo"] as? Int
        {
            internalRouteNo = tmp
        }
        
        if let tmp =  json["AlphaNumericRouteNo"] as? String
        {
            alphaNumericRouteNo = tmp
        }
        
        if let tmp =  json["Destination"] as? String
        {
            destination = tmp
        }
        
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
