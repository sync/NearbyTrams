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
var provider = RoutesProvider(managedObjectContext: managedObjectContext)
provider.getAllRoutesWithManagedObjectContext(managedObjectContext, {
    routes, error -> Void in
    
    if (error)
    {
        println("there was an error dowloading all routes:r \(error!.localizedDescription)")
    }
    else if (routes)
    {
        println("got all routes: \(routes)")
    }
    
    shouldKeepRunning = false
    })

do {
    NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 1))
}
    while (shouldKeepRunning);
