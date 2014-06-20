//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation
import NearbyTramsStorageKit

let baseURL = NSURL(string: "http://www.tramtracker.com")

func parseJSON(inputData: NSData) -> NSDictionary
{
    var dictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
    
    return dictionary
}

func getAllRoutesWithParentManagedObjectContext(parentManagedObjectContext managedObjectContext:NSManagedObjectContext, completionHandler: ((Route[]?, NSError?) -> Void)!) -> NSURLSessionDataTask!
{
    // thanks to: http://wongm.com/2014/03/tramtracker-api-dumphone-access/
    let url = NSURL(string: "Controllers/GetAllRoutes.ashx", relativeToURL:baseURL)
    let session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
    let task = session.dataTaskWithURL(url, completionHandler:{
        data, response, error -> Void in
        
        if (error)
        {
            completionHandler(nil, error)
        }
        else if let routesArray = parseJSON(data)["ResponseObject"] as? NSDictionary[]
        {
            let localContext = NSManagedObjectContext(concurrencyType: .ConfinementConcurrencyType)
            localContext.parentContext = managedObjectContext
            
            let routes = routesArray.map({
                (routeDictionary: NSDictionary) -> Route in
                
                let route = Route.insertInManagedObjectContext(localContext)
                route.configureWithDictionaryFromRest(routeDictionary)
                
                return route
                })
            localContext.save(nil)
            completionHandler(routes, nil)
        }
        })
    task.resume()
    
    return task;
}

var managedObjectContext: NSManagedObjectContext = {
    let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    moc.persistentStoreCoordinator = CoreDataStackManager.sharedInstance.persistentStoreCoordinator
    return moc
    }()

var shouldKeepRunning = true
let allRoutesTask = getAllRoutesWithParentManagedObjectContext(parentManagedObjectContext: managedObjectContext){
    routes, error -> Void in
    
    if (error)
    {
        println("there was an error dowloading all routes: \(error!.localizedDescription)")
    }
    else if (routes)
    {
        println("got all routes")
    }
    
    shouldKeepRunning = false
}

do
{
    NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 1))
}
while (shouldKeepRunning);
