//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import CoreData

class Stop: NSManagedObject, InsertAndFetchManagedObject, RESTManagedObject
{
    @NSManaged var uniqueIdentifier:  NSString?
    
    @NSManaged var stopDescription: String?
    @NSManaged var latitude: NSNumber? // Why when Double it crashes
    @NSManaged var longitude: NSNumber? // Why when Double it crashes
    @NSManaged var name: String?
    @NSManaged var stopNo: NSNumber? // Why when Int it crashes
    @NSManaged var suburb: String?
    @NSManaged var cityDirection: String?
    @NSManaged var zones: String?
    @NSManaged var route : Route?
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
        stopDescription = dictionary["Description"] as? String
        latitude = dictionary["Latitude"] as? Double
        longitude = dictionary["Longitude"] as? Double
        name = dictionary["Name"] as? String
        stopNo = dictionary["StopNo"] as? Int
        suburb = dictionary["SuburbName"] as? String
    }
    
    func configureWithPartialDictionaryFromRest(dictionary: NSDictionary) -> Void
    {
        cityDirection = dictionary["CityDirection"] as? String
        zones = dictionary["Zones"] as? String
    }
}

extension Stop
    {
    var nextScheduledArrivalDates: NSDate[]? {
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
