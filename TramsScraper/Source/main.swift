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
    routes, error -> Void in
    
    if (error)
    {
        println("there was an error dowloading all routes: \(error!.localizedDescription)")
    }
    else if (routes)
    {
        println("found routes: \(routes!.count)")
        
        if routes!.isEmpty
        {
            shouldKeepRunning = false
        }
        else
        {
            var counter = routes!.count
            for (index, route) in enumerate(routes!)
            {
                if let routeNo = route.routeNo
                {
                    stopsProvider.getStopsWithRouteNo(routeNo as Int, managedObjectContext: managedObjectContext) {
                        stops, error -> Void in
                        
                        if (error)
                        {
                            println("there was an error dowloading all stops for route \(routeNo): \(error!.localizedDescription)")
                        }
                        else if (stops)
                        {
                            println("found stops:\(stops!.count) for route: \(routeNo)")
                            
                            route.stops = NSMutableSet(array: stops!)
                            managedObjectContext.save(nil)
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

do {
    NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 1))
} while (shouldKeepRunning)
