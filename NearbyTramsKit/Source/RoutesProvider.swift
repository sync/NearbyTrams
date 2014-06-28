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

    func getAllRoutesWithManagedObjectContext(managedObjectContext: NSManagedObjectContext, completionHandler: ((Route[]?, NSError?) -> Void)?) -> Void
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
                
                let objectIds: NSManagedObjectID[] = Route.insertOrUpdatesRoutesFromRestArray(routes!, inManagedObjectContext: localContext)
                
                localContext.save(nil)
                
                if let handler = completionHandler
                {
                    dispatch_async(dispatch_get_main_queue()) {
                        let fetchedRoutes = Route.fetchAllRoutesForManagedObjectIds(objectIds, usingManagedObjectContext: managedObjectContext)
                        handler(fetchedRoutes.routes, fetchedRoutes.error)
                    }
                }
            }
            else
            {
                // FIXME: build a decent error here
                if let handler = completionHandler
                {
                    dispatch_async(dispatch_get_main_queue()) {
                        handler(nil, nil)
                    }
                }
            }
        }
    }
}
