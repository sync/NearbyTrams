//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation
import NearbyTramsStorageKit
import NearbyTramsNetworkKit
import CoreData

var managedObjectContext: NSManagedObjectContext = {
    let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    moc.persistentStoreCoordinator = CoreDataStackManager.sharedInstance.persistentStoreCoordinator
    return moc
    }()

var shouldKeepRunning = true
let service = NetworkService()
let task = service.getAllRoutesWithCompletionHandler {
    routes, error -> Void in
    
    if (error)
    {
        println("there was an error dowloading all routes: \(error!.localizedDescription)")
    }
    else if (routes)
    {
        let localContext = NSManagedObjectContext(concurrencyType: .ConfinementConcurrencyType)
        localContext.parentContext = managedObjectContext
        
        let coreDataRoutes = routes!.map({
            (routeDictionary: NSDictionary) -> Route in
            
            let route = Route.insertInManagedObjectContext(localContext)
            route.configureWithDictionaryFromRest(routeDictionary)
            
            return route
            })
        localContext.save(nil)
        
        println("got all routes")
    }
    
    shouldKeepRunning = false
}

do
{
    NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 1))
}
    while (shouldKeepRunning);
