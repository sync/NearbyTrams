//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import CoreData

class Schedule: NSManagedObject, InsertAndFetchManagedObject, RESTManagedObject
{
    @NSManaged var uniqueIdentifier: NSString?
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
    @NSManaged var stop : Stop?
    
    class var entityName: String {
        get {
            return "Schedule"
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
        var tmpPredictedArrivalDateTime = dictionary["PredictedArrivalDateTime"] as String
        
        return "\(tmpRouteNo)-\(tmpPredictedArrivalDateTime)"
    }
    
    func configureWithDictionaryFromRest(dictionary: NSDictionary) -> Void
    {
        destination = dictionary["Destination"] as? String
        disruptionMessage = dictionary["DisruptionMessage"] as? Dictionary<String, AnyObject>
        headBoardRouteNo = dictionary["HeadBoardRouteNo"] as? String
        internalRouteNo = dictionary["InternalRouteNo"] as? Int
        routeNo = dictionary["RouteNo"] as? String
        specialEventMessage = dictionary["SpecialEventMessage"] as? String
        tripID = dictionary["TripID"] as? Int
        vehicleNo = dictionary["VehicleNo"] as? Int
        
        if let tmp =  dictionary["PredictedArrivalDateTime"] as? String
        {
            predictedArrivalDateTime = NSDate.fromDonet(tmp)
        }
        
        if let tmp =  dictionary["AirConditioned"] as? Bool
        {
            airConditioned = tmp
        }
        
        if let tmp =  dictionary["DisplayAC"] as? Bool
        {
            displayAC = tmp
        }
        
        if let tmp =  dictionary["HasDisruption"] as? Bool
        {
            hasDisruption = tmp
        }
        
        if let tmp =  dictionary["HasSpecialEvent"] as? Bool
        {
            hasSpecialEvent = tmp
        }
        
        if let tmp =  dictionary["IsLowFloorTram"] as? Bool
        {
            isLowFloorTram = tmp
        }
        
        if let tmp =  dictionary["IsTTAvailable"] as? Bool
        {
            isTTAvailable = tmp
        }
    }
}
