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
    
    func getStopsWithRouteNo(routeNo: Int, isUpDestination: Bool, requestStopInfo: Bool = false, managedObjectContext: NSManagedObjectContext, completionHandler: (([NSManagedObjectID]?, NSError?) -> Void)?) -> Void
    {
        let task = networkService.getStopsByRouteAndDirectionWithRouteNo(routeNo, isUpDestination: isUpDestination) {
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
                
                let result: (stops: [Stop?], errors: [NSError?]) = Stop.insertOrUpdateFromRestArray(stops!, inManagedObjectContext: localContext)
                localContext.save(nil)
                
                var objectIds: [NSManagedObjectID] = []
                
                let group = dispatch_group_create();
                for potentialStop in result.stops
                {
                    if let stop = potentialStop
                    {
                        objectIds.append(stop.objectID)
                        
                        if requestStopInfo
                        {
                            if let stopNo: Int = stop.stopNo?.integerValue
                            {
                                dispatch_group_enter(group);
                                self.getStopInformationWithStopNo(stopNo, managedObjectContext: managedObjectContext) {
                                    objectId, stopInformationError -> Void in
                                    
                                    dispatch_group_leave(group);
                                }
                            }
                        }
                    }
                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
                    
                    if let handler = completionHandler
                    {
                        dispatch_async(dispatch_get_main_queue()) {
                            handler(objectIds, nil)
                        }
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
    
    func getStopInformationWithStopNo(stopNo: Int, managedObjectContext: NSManagedObjectContext, completionHandler: ((NSManagedObjectID?, NSError?) -> Void)?) -> Void
    {
        let task = networkService.getStopInformationWithStopNo(stopNo) {
            dictionary, error -> Void in
            
            if (error)
            {
                if let handler = completionHandler
                {
                    dispatch_async(dispatch_get_main_queue()) {
                        handler(nil, error)
                    }
                }
            }
            else if (dictionary)
            {
                let localContext = NSManagedObjectContext(concurrencyType: .ConfinementConcurrencyType)
                localContext.parentContext = managedObjectContext
                
                let result: (managedObject: Stop?, error: NSError?) = Stop.fetchOneForPrimaryKeyValue(String(stopNo), usingManagedObjectContext: managedObjectContext)
                if let foundStop = result.managedObject
                {
                    foundStop.configureWithPartialDictionaryFromRest(dictionary!)
                    localContext.save(nil)
                    
                    if let handler = completionHandler
                    {
                        dispatch_async(dispatch_get_main_queue()) {
                            handler(foundStop.objectID, nil)
                        }
                    }
                }
                else
                {
                    if let handler = completionHandler
                    {
                        dispatch_async(dispatch_get_main_queue()) {
                            handler(nil, result.error)
                        }
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

