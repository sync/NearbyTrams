//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation
import NearbyTramsStorageKit
import NearbyTramsNetworkKit

class StopsProvider
{
    let networkService: NetworkService
    let managedObjectContext: NSManagedObjectContext
    
    init (networkService: NetworkService =  NetworkService(), managedObjectContext: NSManagedObjectContext)
    {
        self.networkService = networkService
        self.managedObjectContext = managedObjectContext
    }
    
    func getStopsWithRouteNo(routeNo: Int, managedObjectContext: NSManagedObjectContext, completionHandler: ((Stop[]?, NSError?) -> Void)?) -> Void
    {
        let task = networkService.getStopsByRouteAndDirectionWithRouteNo(routeNo) {
            stops, error -> Void in
            
            if (error)
            {
                if let handler = completionHandler
                {
                    dispatch_async(dispatch_get_main_queue()) {
                        handler(nil, error)
                    }
                }
            }
            else if (stops)
            {
                let localContext = NSManagedObjectContext(concurrencyType: .ConfinementConcurrencyType)
                localContext.parentContext = managedObjectContext
                
                
                let result: (stops: Stop?[], errors: NSError?[]) = Stop.insertOrUpdateFromRestArray(stops!, inManagedObjectContext: localContext)
                
                var objectIds: NSManagedObjectID[] = []
                for potentialStop in result.stops
                {
                    if let stop = potentialStop
                    {
                        objectIds.append(stop.objectID)
                    }
                }
                
                localContext.save(nil)
                
                if let handler = completionHandler
                {
                    dispatch_async(dispatch_get_main_queue()) {
                        let fetchedStops: (stops: Stop[]?, error:NSError?) = Stop.fetchAllForManagedObjectIds(objectIds, usingManagedObjectContext: managedObjectContext)
                        handler(fetchedStops.stops, fetchedStops.error)
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

