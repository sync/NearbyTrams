//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Cocoa
import Foundation
import NearbyTramsStorageKit
import NearbyTramsNetworkKit
import CoreData
import NearbyTramsKit

func printHelpForAppNamed(appName: String)
{
    println("Usage: \(appName) [-6] [-o <path>] [-f <path>] [-p <prefix>] [<paths>]\n")
    println("       \(appName) -h\n\n")
    println("Options:\n")
    println("    -d <path>      Database <path>, required\n")
    println("    -stopInfo      Include additional stop info\n")
    println("    -schedules     Include schedules\n")
    println("    -h             Print this help and exit\n")
}

let arguments = Process.arguments

let shouldPrintHelp = contains(arguments as [String], "-h")
if shouldPrintHelp
{
    let appName = arguments[0].lastPathComponent
    printHelpForAppNamed(appName)
    
    exit(0)
}

let shouldRequestStopInfo = contains(arguments as [String], "-stopInfo")
let shouldRequestSchedules = contains(arguments as [String], "-schedules")

let managedObjectContext: NSManagedObjectContext = {
    let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    moc.persistentStoreCoordinator = CoreDataStackManager.sharedInstance.persistentStoreCoordinator
    return moc
    }()

let group = dispatch_group_create();

var routesProvider = RoutesProvider(managedObjectContext: managedObjectContext)
var stopsProvider = StopsProvider(managedObjectContext: managedObjectContext)

dispatch_group_enter(group)
routesProvider.getAllRoutesWithManagedObjectContext(managedObjectContext) {
    routeObjectIds, error -> Void in
    
    if (routeObjectIds)
    {
        println("found routes: \(routeObjectIds!.count)")
        
        let fetchedRoutes: (routes: [Route]?, error:NSError?) = Route.fetchAllForManagedObjectIds(routeObjectIds!, usingManagedObjectContext: managedObjectContext)
        if let routes = fetchedRoutes.routes
        {
            for (index, route) in enumerate(routes)
            {
                if let routeNo = route.routeNo
                {
                    dispatch_group_enter(group)
                    stopsProvider.getStopsWithRouteNo(routeNo as Int, isUpDestination: route.isUpDestination, requestStopInfo: shouldRequestStopInfo, managedObjectContext: managedObjectContext) {
                        stopObjectIds, error -> Void in
                        
                        if (stopObjectIds)
                        {
                            println("found stops:\(stopObjectIds!.count) for route: \(routeNo), up destination: \(route.isUpDestination)")
                            
                            let fetchedStops: (stops: [Stop]?, error:NSError?) = Stop.fetchAllForManagedObjectIds(stopObjectIds!, usingManagedObjectContext: managedObjectContext)
                            if let stops = fetchedStops.stops
                            {
                                route.stops = NSMutableSet(array: stops)
                                managedObjectContext.save(nil)
                            }
                        }
                        else
                        {
                            println("there was an error dowloading all stops for route \(routeNo): \(error?.localizedDescription)")
                        }
                        
                        dispatch_group_leave(group)
                    }
                }
            }
        }
    }
    else
    {
        println("there was an error dowloading all routes: \(error?.localizedDescription)")
    }
    
    dispatch_group_leave(group)
}

var shouldKeepRunning = true

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    dispatch_async(dispatch_get_main_queue()) {
        shouldKeepRunning = false
    }
}

do {
    NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 1))
} while (shouldKeepRunning)
