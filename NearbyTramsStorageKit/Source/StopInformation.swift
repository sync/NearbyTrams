//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import CoreData

class StopInformation: NSManagedObject
{
    @NSManaged var cityDirection: String
    @NSManaged var stopDescription: String
    @NSManaged var destination: String
    @NSManaged var distanceToLocation: Double
    @NSManaged var flagStopNo: String
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var routeNo: NSNumber // Why when Int it crashes
    @NSManaged var stopID: String
    @NSManaged var stopName: String
    @NSManaged var stopNo: NSNumber // Why when Int it crashes
    @NSManaged var suburb: String
    
    class func insertInManagedObjectContext(managedObjectContext: NSManagedObjectContext) -> StopInformation
    {
        return NSEntityDescription.insertNewObjectForEntityForName("StopInformation", inManagedObjectContext: managedObjectContext) as StopInformation
    }
    
    func configureWithDictionaryFromRest(json: NSDictionary) -> Void
    {
        if let tmp =  json["CityDirection"] as? String
        {
            cityDirection = tmp
        }
        
        if let tmp =  json["Description"] as? String
        {
            stopDescription = tmp
        }
        
        if let tmp =  json["Destination"] as? String
        {
            destination = tmp
        }
        
        if let tmp =  json["DistanceToLocation"] as? Double
        {
            distanceToLocation = tmp
        }
        
        if let tmp =  json["FlagStopNo"] as? String
        {
            flagStopNo = tmp
        }
        
        if let tmp =  json["Latitude"] as? Double
        {
            latitude = tmp
        }
        
        if let tmp =  json["Longitude"] as? Double
        {
            longitude = tmp
        }
        
        if let tmp =  json["RouteNo"] as? Int
        {
            routeNo = tmp
        }
        
        if let tmp =  json["StopID"] as? String
        {
            stopID = tmp
        }
        
        if let tmp =  json["StopName"] as? String
        {
            stopName = tmp
        }
        
        if let tmp =  json["StopNo"] as? Int
        {
            stopNo = tmp
        }
        
        if let tmp =  json["Suburb"] as? String
        {
            suburb = tmp
        }
    }
}
