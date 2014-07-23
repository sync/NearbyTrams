//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import CoreData

public class Stop: NSManagedObject, InsertAndFetchManagedObject, RESTManagedObject
{
    @NSManaged public var uniqueIdentifier: String?
    @NSManaged public var stopDescription: String?
    @NSManaged public var latitude: NSNumber? // Why when Double it crashes
    @NSManaged public var longitude: NSNumber? // Why when Double it crashes
    @NSManaged public var name: String?
    @NSManaged public var stopNo: NSNumber? // Why when Int it crashes
    @NSManaged public var suburb: String?
    @NSManaged public var isUpStop: Bool
    @NSManaged public var cityDirection: String?
    @NSManaged public var zones: String?
    @NSManaged public var route : Route?
    @NSManaged public var schedules : NSMutableSet
    
    public class var entityName: String {
        get {
            return "Stop"
    }
    }
    
    public class var primaryKey: String {
        get {
            return "uniqueIdentifier"
    }
    }
    
    public class func primaryKeyValueFromRest(dictionary: NSDictionary) -> String?
    {
        if let intValue = dictionary["StopNo"] as? Int
        {
            return String(intValue)
        }
        
        return nil
    }
    
    public func configureWithDictionaryFromRest(dictionary: NSDictionary) -> Void
    {
        stopDescription = dictionary["Description"] as? String
        latitude = dictionary["Latitude"] as? Double
        longitude = dictionary["Longitude"] as? Double
        name = dictionary["StopName"] as? String
        stopNo = dictionary["StopNo"] as? Int
        suburb = dictionary["SuburbName"] as? String
        
        if let tmp =  dictionary["UpStop"] as? Bool
        {
            isUpStop = tmp
        }
    }
    
    public func configureWithPartialDictionaryFromRest(dictionary: NSDictionary) -> Void
    {
        cityDirection = dictionary["CityDirection"] as? String
        zones = dictionary["Zones"] as? String
    }
}

public extension Stop
    {
    public var nextScheduledArrivalDates: [NSDate]? {
    if let identifier = self.uniqueIdentifier
    {
        let fetchRequest = NSFetchRequest(entityName: Schedule.entityName)
        fetchRequest.fetchLimit = 3
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "predictedArrivalDateTime", ascending: true)]
        fetchRequest.predicate = NSPredicate(format:"stop.uniqueIdentifier == %@ AND predictedArrivalDateTime >= %@", identifier, NSDate())
        
        let arrivalDates = self.managedObjectContext.executeFetchRequest(fetchRequest, error: nil).map {
            schedule -> NSDate in
            
            return (schedule as Schedule).predictedArrivalDateTime!
        }
        
        return arrivalDates
        }
        return nil
    }
}
