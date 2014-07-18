//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import CoreData

class Route: NSManagedObject, InsertAndFetchManagedObject, RESTManagedObject
{
    @NSManaged var uniqueIdentifier: NSString?
    @NSManaged var routeNo: String?
    @NSManaged var name: String?
    @NSManaged var isUpStop: Bool
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
        let tmpRouteNo =  dictionary["RouteNumber"] as? String
        var tmpIsUpStop = false
        if let tmp =  dictionary["IsUpStop"] as? Bool
        {
            tmpIsUpStop = tmp
        }
        
        return "\(tmpRouteNo)-\(tmpIsUpStop)"
    }
    
    func configureWithDictionaryFromRest(dictionary: NSDictionary) -> Void
    {
        routeNo =  dictionary["RouteNumber"] as? String
        name = dictionary["Name"] as? String
        
        if let tmp =  dictionary["IsUpStop"] as? Bool
        {
            isUpStop = tmp
        }
    }
}
