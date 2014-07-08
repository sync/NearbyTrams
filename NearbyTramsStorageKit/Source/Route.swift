//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import CoreData

class Route: NSManagedObject, InsertAndFetchManagedObject, RESTManagedObject
{
    @NSManaged var uniqueIdentifier:  NSString?
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
            return "uniqueIdentifier"
    }
    }
    
    class func primaryKeyValueFromRest(dictionary: NSDictionary) -> String?
    {
        let tmpRouteNo =  dictionary["RouteNo"] as? Int
        var tmpIsUpDestination = false
        if let tmp =  dictionary["IsUpDestination"] as? Bool
        {
            tmpIsUpDestination = tmp
        }
        
        return "\(tmpRouteNo)-\(tmpIsUpDestination)"
    }
    
    func configureWithDictionaryFromRest(dictionary: NSDictionary) -> Void
    {
        routeNo =  dictionary["RouteNo"] as? Int
        internalRouteNo = dictionary["InternalRouteNo"] as? Int
        alphaNumericRouteNo = dictionary["AlphaNumericRouteNo"] as? String
        destination = dictionary["Destination"] as? String
        
        if let tmp =  dictionary["IsUpDestination"] as? Bool
        {
            isUpDestination = tmp
        }
        
        if let tmp =  dictionary["HasLowFloor"] as? Bool
        {
            hasLowFloor = tmp
        }
    }
}
