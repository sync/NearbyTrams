//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation
import NearbyTramsStorageKit

public protocol SchedulesRepositoryDelegate
{
    func schedulesRepositoryLoadingStateDidChange(repository: SchedulesRepository, isLoading loading: Bool) -> Void
    func schedulesRepositoryDidFinsishLoading(repository: SchedulesRepository, error: NSError?) -> Void
}

public class SchedulesRepository
{
    public var delegate: SchedulesRepositoryDelegate?
    
    let routeIdentifier: String
    let stopIdentifier: String
    let schedulesProvider: SchedulesProvider
    let managedObjectContext: NSManagedObjectContext
    public var isLoading: Bool {
    willSet {
        self.delegate?.schedulesRepositoryLoadingStateDidChange(self, isLoading: newValue)
    }
    }
    
    public init (routeIdentifier: String, stopIdentifier: String, schedulesProvider: SchedulesProvider, managedObjectContext: NSManagedObjectContext)
    {
        self.routeIdentifier = routeIdentifier
        self.stopIdentifier = stopIdentifier
        self.schedulesProvider = schedulesProvider
        self.managedObjectContext = managedObjectContext
        self.isLoading = false
    }
    
    func fetchRoute() -> Route?
    {
        let result: (managedObject: Route?, error: NSError?) = Route.fetchOneForPrimaryKeyValue(self.routeIdentifier, usingManagedObjectContext: self.managedObjectContext)
        return result.managedObject
    }
    
    func fetchStop() -> Stop?
    {
        let result: (managedObject: Stop?, error: NSError?) = Stop.fetchOneForPrimaryKeyValue(self.stopIdentifier, usingManagedObjectContext: self.managedObjectContext)
        return result.managedObject
    }
    
    public func update() -> Void
    {
        if let stop = fetchStop()
        {
            let fetchedRouteNo = fetchRoute()?.routeNo
            let fetchedStopNo = stop.stopNo as? Int
            if fetchedRouteNo && fetchedStopNo
            {
                let routeNo = fetchedRouteNo!
                let stopNo = fetchedStopNo!
                
                self.isLoading = true
                schedulesProvider.getNextPredictionsWithStopNo(stopNo, routeNo: routeNo, managedObjectContext: managedObjectContext) {
                    scheduleObjectIds, error -> Void in
                    
                    if let objectIds = scheduleObjectIds
                    {
                        let result: (schedules: [Schedule]?, error:NSError?) = Schedule.fetchAllForManagedObjectIds(objectIds, usingManagedObjectContext: self.managedObjectContext)
                        if let schedules = result.schedules
                        {
                            stop.schedules = NSMutableSet(array: schedules)
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
