//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import CoreData

class Schedule: NSManagedObject
{
    @NSManaged var airConditioned: Bool
    @NSManaged var destination: String?
    @NSManaged var displayAC: Bool
    @NSManaged var disruptionMessage: Dictionary<String, AnyObject>?
    @NSManaged var hasDisruption: Bool
    @NSManaged var hasSpecialEvent: Bool
    @NSManaged var headBoardRouteNo: String?
    @NSManaged var internalRouteNo: NSNumber? // Why when Int it crashes
    @NSManaged var isLowFloorTram: Bool
    @NSManaged var isTTAvailable: Bool
    @NSManaged var predictedArrivalDateTime: NSDate?
    @NSManaged var routeNo: String?
    @NSManaged var specialEventMessage: String?
    @NSManaged var tripID: NSNumber? // Why when Int it crashes
    @NSManaged var vehicleNo: NSNumber? // Why when Int it crashes
    
    class func insertInManagedObjectContext(managedObjectContext: NSManagedObjectContext) -> Schedule
    {
        return NSEntityDescription.insertNewObjectForEntityForName("Schedule", inManagedObjectContext: managedObjectContext) as Schedule
    }
    
    func configureWithDictionaryFromRest(json: NSDictionary) -> Void
    {
        destination = json["Destination"] as? String
        disruptionMessage = json["DisruptionMessage"] as? Dictionary<String, AnyObject>
        headBoardRouteNo = json["HeadBoardRouteNo"] as? String
        internalRouteNo = json["InternalRouteNo"] as? Int
        routeNo = json["RouteNo"] as? String
        specialEventMessage = json["SpecialEventMessage"] as? String
        tripID = json["TripID"] as? Int
        vehicleNo = json["VehicleNo"] as? Int
        
        if let tmp =  json["PredictedArrivalDateTime"] as? NSString
        {
            predictedArrivalDateTime = NSDate.fromDonet(tmp)
        }
        
        if let tmp =  json["AirConditioned"] as? Bool
        {
            airConditioned = tmp
        }
        
        if let tmp =  json["DisplayAC"] as? Bool
        {
            displayAC = tmp
        }
        
        if let tmp =  json["HasDisruption"] as? Bool
        {
            hasDisruption = tmp
        }
        
        if let tmp =  json["HasSpecialEvent"] as? Bool
        {
            hasSpecialEvent = tmp
        }
        
        if let tmp =  json["IsLowFloorTram"] as? Bool
        {
            isLowFloorTram = tmp
        }
        
        if let tmp =  json["IsTTAvailable"] as? Bool
        {
            isTTAvailable = tmp
        }
    }
}
