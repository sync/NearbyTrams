//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import CoreData

public class Route: NSManagedObject, InsertAndFetchManagedObject, RESTManagedObject
{
    @NSManaged public var uniqueIdentifier: String?
    @NSManaged public var routeNo: String?
    @NSManaged public var internalRouteNo: NSNumber? // Why when Int it crashes
    @NSManaged public var routeDescription: String?
    @NSManaged public var downDestination: String?
    @NSManaged public var upDestination: String?
    @NSManaged public var color: String?
    @NSManaged public var stops : NSMutableSet
    
    public class var entityName: String {
        get {
            return "Route"
    }
    }
    
    public class var primaryKey: String {
        get {
            return "uniqueIdentifier"
    }
    }
    
    public class func primaryKeyValueFromRest(dictionary: NSDictionary) -> String?
    {
        if let tmpRouteNo =  dictionary["RouteNo"] as? String
        {
            return tmpRouteNo
        }
        
        return nil
    }
    
    public func configureWithDictionaryFromRest(dictionary: NSDictionary) -> Void
    {
        routeNo =  dictionary["RouteNo"] as? String
        internalRouteNo =  dictionary["InternalRouteNo"] as? Int
        routeDescription =  dictionary["Description"] as? String
        downDestination =  dictionary["DownDestination"] as? String
        upDestination =  dictionary["UpDestination"] as? String
        color =  dictionary["RouteColour"] as? String
    }
}
