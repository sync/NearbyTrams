//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation
import NearbyTramsStorageKit
import NearbyTramsNetworkKit

class SchedulesProvider
{
    let networkService: NetworkService
    let managedObjectContext: NSManagedObjectContext
    
    init (networkService: NetworkService =  NetworkService(), managedObjectContext: NSManagedObjectContext)
    {
        self.networkService = networkService
        self.managedObjectContext = managedObjectContext
    }
    
    func getNextPredictionsWithStopNo(stopNo: Int, managedObjectContext: NSManagedObjectContext, completionHandler: (([NSManagedObjectID]?, NSError?) -> Void)?) -> Void
    {
        let task = networkService.getNextPredictionsWithStopNo(stopNo, timestamp: NSDate()) {
            schedules, error -> Void in
            
            if (error)
            {
                if let handler = completionHandler
                {
                    dispatch_async(dispatch_get_main_queue()) {
                        handler(nil, error)
                    }
                }
            }
            else if (schedules)
            {
                let localContext = NSManagedObjectContext(concurrencyType: .ConfinementConcurrencyType)
                localContext.parentContext = managedObjectContext
                
                let result: (schedules: [Schedule?], errors: [NSError?]) = Schedule.insertOrUpdateFromRestArray(schedules!, inManagedObjectContext: localContext)
                localContext.save(nil)
                
                var objectIds: [NSManagedObjectID] = []
                for potentialSchedule in result.schedules
                {
                    if let schedule = potentialSchedule
                    {
                        objectIds.append(schedule.objectID)
                    }
                }
                
                if let handler = completionHandler
                {
                    dispatch_async(dispatch_get_main_queue()) {
                        handler(objectIds, nil)
                    }
                }
            }
            else
            {
                if let handler = completionHandler
                {
                    dispatch_async(dispatch_get_main_queue()) {
                        // FIXME: build a decent error here
                        let error = NSError()
                        handler(nil, error)
                    }
                }
            }
        }
    }
}

