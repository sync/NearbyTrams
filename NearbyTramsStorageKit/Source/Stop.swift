//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import CoreData

class Stop: NSManagedObject, InsertAndFetchManagedObject, RESTManagedObject
{
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
    
    class var entityName: String {
        get {
            return "Stop"
    }
    }
    
    class var primaryKey: String {
        get {
            return "stopNo"
    }
    }
    
    class var primaryKeyFromRest: String {
        get {
            return "StopNo"
    }
    }
    
    func configureWithDictionaryFromRest(json: NSDictionary) -> Void
    {
        cityDirection = json["CityDirection"] as? String
        stopDescription = json["Description"] as? String
        destination = json["Destination"] as? String
        flagStopNo = json["FlagStopNo"] as? String
        routeNo = json["RouteNo"] as? Int
        stopID =  json["StopID"] as? String
        stopName = json["StopName"] as? String
        stopNo = json["StopNo"] as? Int
        suburb = json["Suburb"] as? String
        distanceToLocation = json["DistanceToLocation"] as? Double
        latitude = json["Latitude"] as? Double
        longitude = json["Longitude"] as? Double
    }
    
    func configureWithPartialDictionaryFromRest(json: NSDictionary) -> Void
    {
        cityDirection = json["CityDirection"] as? String
        flagStopNo = json["FlagStopNo"] as? String
        stopName = json["StopName"] as? String
    }
}
