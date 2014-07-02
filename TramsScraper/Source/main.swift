//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation
import NearbyTramsStorageKit
import NearbyTramsNetworkKit
import CoreData
import NearbyTramsKit

var managedObjectContext: NSManagedObjectContext = {
    let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    moc.persistentStoreCoordinator = CoreDataStackManager.sharedInstance.persistentStoreCoordinator
    return moc
    }()

var shouldKeepRunning = true
var routesProvider = RoutesProvider(managedObjectContext: managedObjectContext)
var stopsProvider = StopsProvider(managedObjectContext: managedObjectContext)

routesProvider.getAllRoutesWithManagedObjectContext(managedObjectContext) {
    routeObjectIds, error -> Void in
    
    if (error)
    {
        println("there was an error dowloading all routes: \(error!.localizedDescription)")
    }
    else if (routeObjectIds)
    {
        println("found routes: \(routeObjectIds!.count)")
        
        if routeObjectIds!.isEmpty
        {
            shouldKeepRunning = false
        }
        else
        {
            let fetchedRoutes: (routes: Route[]?, error:NSError?) = Route.fetchAllForManagedObjectIds(routeObjectIds!, usingManagedObjectContext: managedObjectContext)
            if let routes = fetchedRoutes.routes
            {
                var counter = routes.count
                for (index, route) in enumerate(routes)
                {
                    if let routeNo = route.routeNo
                    {
                        stopsProvider.getStopsWithRouteNo(routeNo as Int, requestStopInfo: true, managedObjectContext: managedObjectContext) {
                            stopObjectIds, error -> Void in
                            
                            if (error)
                            {
                                println("there was an error dowloading all stops for route \(routeNo): \(error!.localizedDescription)")
                            }
                            else if (stopObjectIds)
                            {
                                println("found stops:\(stopObjectIds!.count) for route: \(routeNo)")
                                
                                let fetchedStops: (stops: Stop[]?, error:NSError?) = Stop.fetchAllForManagedObjectIds(stopObjectIds!, usingManagedObjectContext: managedObjectContext)
                                if let stops = fetchedStops.stops
                                {
                                    route.stops = NSMutableSet(array: stops)
                                    managedObjectContext.save(nil)
                                }
                            }
                            
                            --counter
                            shouldKeepRunning = counter != 0
                        }
                    }
                    else
                    {
                        --counter
                        shouldKeepRunning = counter != 0
                    }
                }
            }

        }
    }
}

do {
    NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 1))
} while (shouldKeepRunning)
