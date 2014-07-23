//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import CoreData

public class Schedule: NSManagedObject, InsertAndFetchManagedObject, RESTManagedObject
{
    @NSManaged public var uniqueIdentifier: String?
    @NSManaged public var airConditioned: Bool
    @NSManaged public var destination: String?
    @NSManaged public var displayAC: Bool
    @NSManaged public var disruptionMessage: Dictionary<String, AnyObject>?
    @NSManaged public var hasDisruption: Bool
    @NSManaged public var hasSpecialEvent: Bool
    @NSManaged public var headBoardRouteNo: String?
    @NSManaged public var internalRouteNo: NSNumber? // Why when Int it crashes
    @NSManaged public var isLowFloorTram: Bool
    @NSManaged public var isTTAvailable: Bool
    @NSManaged public var predictedArrivalDateTime: NSDate?
    @NSManaged public var routeNo: String?
    @NSManaged public var specialEventMessage: String?
    @NSManaged public var tripID: NSNumber? // Why when Int it crashes
    @NSManaged public var vehicleNo: NSNumber? // Why when Int it crashes
    @NSManaged public var stop : Stop?
    
    public class var entityName: String {
        get {
            return "Schedule"
    }
    }
    
    public class var primaryKey: String {
        get {
            return "uniqueIdentifier"
    }
    }
    
    public class func primaryKeyValueFromRest(dictionary: NSDictionary) -> String?
    {
        let tmpRouteNo =  dictionary["RouteNo"] as? String
        let tmpPredictedArrivalDateTime = dictionary["PredictedArrivalDateTime"] as? String
        
        if tmpRouteNo && tmpPredictedArrivalDateTime
        {
            return "\(tmpRouteNo)-\(tmpPredictedArrivalDateTime)"
        }
        
        return nil
    }
    
    public func configureWithDictionaryFromRest(dictionary: NSDictionary) -> Void
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
