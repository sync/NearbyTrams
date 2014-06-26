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

let service = NetworkService()
func getAllRoutesWithCompletionHandler(completionHandler: ((NSManagedObjectID[]?, NSError?) -> Void)?) -> Void
{
    let task = service.getAllRoutesWithCompletionHandler {
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
            
            let routesObjectIds = routes!.map {
                (routeDictionary: NSDictionary) -> NSManagedObjectID in
                
                let route = Route.insertInManagedObjectContext(localContext)
                route.configureWithDictionaryFromRest(routeDictionary)
                localContext.obtainPermanentIDsForObjects([route], error: nil)
                
                return route.objectID
            }
            
            localContext.save(nil)
            
            if let handler = completionHandler
            {
                dispatch_async(dispatch_get_main_queue()) {
                    handler(routesObjectIds, nil)
                }
            }
        }
    }
}

var shouldKeepRunning = true
getAllRoutesWithCompletionHandler {
    routesObjectIds, error -> Void in
    
    if (error)
    {
        println("there was an error dowloading all routes:r \(error!.localizedDescription)")
    }
    else if (routesObjectIds)
    {
        let predicate = NSPredicate(format:"self IN %@", routesObjectIds!)
        let request = NSFetchRequest(entityName: "Route")
        request.predicate = predicate
        
        //func executeFetchRequest(request: NSFetchRequest!, error: NSErrorPointer) -> AnyObject[]!
        if let routes = managedObjectContext.executeFetchRequest(request, error: nil)
        {
            println("got all routes: \(routes)")
        }
    }
    
    shouldKeepRunning = false
}

do {
    NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 1))
}
    while (shouldKeepRunning);
