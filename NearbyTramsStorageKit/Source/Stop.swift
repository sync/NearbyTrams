//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import CoreData

class Stop: NSManagedObject, InsertAndFetchManagedObject, RESTManagedObject
{
    @NSManaged var uniqueIdentifier:  NSString?
    @NSManaged var cityDirection: String?
    @NSManaged var stopDescription: String?
    @NSManaged var destination: String?
    @NSManaged var distanceToLocation: NSNumber? // Why when Double it crashes
    @NSManaged var flagStopNo: String?
    @NSManaged var latitude: NSNumber? // Why when Double it crashes
    @NSManaged var longitude: NSNumber? // Why when Double it crashes
    @NSManaged var routeNo: NSNumber? // Why when Int it crashes
    @NSManaged var stopID: String?
    @NSManaged var stopName: String?
    @NSManaged var stopNo: NSNumber? // Why when Int it crashes
    @NSManaged var suburb: String?
    @NSManaged var route : Route
    @NSManaged var schedules : NSMutableSet
    
    class var entityName: String {
        get {
            return "Stop"
    }
    }
    
    class var primaryKey: String {
        get {
            return "uniqueIdentifier"
    }
    }
    
    class func primaryKeyValueFromRest(dictionary: NSDictionary) -> String?
    {
        if let intValue = dictionary["StopNo"] as? Int
        {
            return String(intValue)
        }
        
        return nil
    }
    
    func configureWithDictionaryFromRest(dictionary: NSDictionary) -> Void
    {
        cityDirection = dictionary["CityDirection"] as? String
        stopDescription = dictionary["Description"] as? String
        destination = dictionary["Destination"] as? String
        flagStopNo = dictionary["FlagStopNo"] as? String
        routeNo = dictionary["RouteNo"] as? Int
        stopID =  dictionary["StopID"] as? String
        stopName = dictionary["StopName"] as? String
        stopNo = dictionary["StopNo"] as? Int
        suburb = dictionary["Suburb"] as? String
        distanceToLocation = dictionary["DistanceToLocation"] as? Double
        latitude = dictionary["Latitude"] as? Double
        longitude = dictionary["Longitude"] as? Double
    }
    
    func configureWithPartialDictionaryFromRest(dictionary: NSDictionary) -> Void
    {
        cityDirection = dictionary["CityDirection"] as? String
        flagStopNo = dictionary["FlagStopNo"] as? String
        stopName = dictionary["StopName"] as? String
    }
}
