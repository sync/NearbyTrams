//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation
import NearbyTramsStorageKit
import NearbyTramsNetworkKit

class RoutesProvider
{
    let networkService: NetworkService
    let managedObjectContext: NSManagedObjectContext
    
    init (networkService: NetworkService =  NetworkService(), managedObjectContext: NSManagedObjectContext)
    {
        self.networkService = networkService
        self.managedObjectContext = managedObjectContext
    }
    
    func getAllRoutesWithManagedObjectContext(managedObjectContext: NSManagedObjectContext, completionHandler: (([NSManagedObjectID]?, NSError?) -> Void)?) -> Void
    {
        let task = networkService.getAllRoutesWithCompletionHandler {
            routes, error -> Void in
            
            if (error)
            {
                if let handler = completionHandler
                {
                    dispatch_async(dispatch_get_main_queue()) {
                        handler(nil, error)
                    }
                }
            }
            else if (routes)
            {
                let localContext = NSManagedObjectContext(concurrencyType: .ConfinementConcurrencyType)
                localContext.parentContext = managedObjectContext
                
                
                let result: (routes: [Route?], errors: [NSError?]) = Route.insertOrUpdateFromRestArray(routes!, inManagedObjectContext: localContext)
                localContext.save(nil)
                
                var objectIds: [NSManagedObjectID] = []
                for potentialRoute in result.routes
                {
                    if let route = potentialRoute
                    {
                        objectIds.append(route.objectID)
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
