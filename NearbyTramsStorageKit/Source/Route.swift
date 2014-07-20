//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import CoreData

class Route: NSManagedObject, InsertAndFetchManagedObject, RESTManagedObject
{    
    @NSManaged var uniqueIdentifier: NSString?
    @NSManaged var routeNo: String?
    @NSManaged var internalRouteNo: NSNumber? // Why when Int it crashes
    @NSManaged var routeDescription: String?
    @NSManaged var downDestination: String?
    @NSManaged var upDestination: String?
    @NSManaged var color: String?
    @NSManaged var stops : NSMutableSet
    
    class var entityName: String {
        get {
            return "Route"
    }
    }
    
    class var primaryKey: String {
        get {
            return "uniqueIdentifier"
    }
    }
    
    class func primaryKeyValueFromRest(dictionary: NSDictionary) -> String?
    {
        if let tmpRouteNo =  dictionary["RouteNo"] as? String
        {
           return tmpRouteNo
        }
        
        return nil
    }
    
    func configureWithDictionaryFromRest(dictionary: NSDictionary) -> Void
    {
        routeNo =  dictionary["RouteNo"] as? String
        internalRouteNo =  dictionary["InternalRouteNo"] as? Int
        routeDescription =  dictionary["Description"] as? String
        downDestination =  dictionary["DownDestination"] as? String
        upDestination =  dictionary["UpDestination"] as? String
        color =  dictionary["RouteColour"] as? String
    }
}
