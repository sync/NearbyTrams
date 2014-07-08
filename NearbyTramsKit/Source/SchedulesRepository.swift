//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation
import NearbyTramsStorageKit

protocol SchedulesRepositoryDelegate
{
    func schedulesRepositoryLoadingStateDidChange(repository: SchedulesRepository, isLoading loading: Bool) -> Void
    func schedulesRepositoryDidFinsishLoading(repository: SchedulesRepository, error: NSError?) -> Void
}

class SchedulesRepository
{
    var delegate: SchedulesRepositoryDelegate?
    
    let stopIdentifier: String
    let schedulesProvider: SchedulesProvider
    let managedObjectContext: NSManagedObjectContext
    var isLoading: Bool {
    willSet {
        self.delegate?.schedulesRepositoryLoadingStateDidChange(self, isLoading: newValue)
    }
    }
    
    init (stopIdentifier: String, schedulesProvider: SchedulesProvider, managedObjectContext: NSManagedObjectContext)
    {
        self.stopIdentifier = stopIdentifier
        self.schedulesProvider = schedulesProvider
        self.managedObjectContext = managedObjectContext
        self.isLoading = false
    }
    
    func fetchStop() -> Stop?
    {
        let result: (managedObject: Stop?, error: NSError?) = Stop.fetchOneForPrimaryKeyValue(self.stopIdentifier, usingManagedObjectContext: self.managedObjectContext)
        return result.managedObject
    }
    
    func update() -> Void
    {
        if let stop = fetchStop()
        {
            if let stopNo = stop.stopNo as? Int
            {
                self.isLoading = true
                schedulesProvider.getNextPredictionsWithStopNo(stopNo, managedObjectContext: managedObjectContext) {
                    scheduleObjectIds, error -> Void in
                    
                    if let objectIds = scheduleObjectIds
                    {
                        let result: (schedules: Schedule[]?, error:NSError?) = Schedule.fetchAllForManagedObjectIds(objectIds, usingManagedObjectContext: self.managedObjectContext)
                        if let stops = result.schedules
                        {
                            stop.schedules = NSMutableSet(array: stops)
                            self.managedObjectContext.save(nil)
                        }
                    }
                    
                    self.isLoading = false
                    self.delegate?.schedulesRepositoryDidFinsishLoading(self, error: error)
                }
            }
        }
    }
}
