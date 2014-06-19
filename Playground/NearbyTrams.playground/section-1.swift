// Playground - noun: a place where people can play

import XCPlayground
import Cocoa
import CoreData

class CoreDataStore
{
    let managedObjectContext: NSManagedObjectContext = {
        var _managedObjectContext: NSManagedObjectContext? = nil
        let databaseName = "NearbyTrams"
        var databaseURL = NSURL(fileURLWithPath: databaseName + ".sqlite")
        if let url = NSBundle.mainBundle().URLForResource(databaseName, withExtension: "sqlite")
        {
            println("found it")
            
            databaseURL = url
        }
        
        let modelURL = NSBundle.mainBundle().URLForResource(databaseName, withExtension: "momd")
        let managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)
        
        var error: NSError? = nil
        let persistentStoreCoordinator:NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        if persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType,
            configuration: nil,
            URL: databaseURL,
            options: nil,
            error: &error) == nil
        {
            println("there was an error: \(error!.localizedDescription)")
            abort()
        }
        
        _managedObjectContext = NSManagedObjectContext()
        _managedObjectContext!.persistentStoreCoordinator = persistentStoreCoordinator
        
        
        return _managedObjectContext!
    }()
}

func parseJSON(inputData: NSData) -> NSDictionary
{
    var dictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
    
    return dictionary
}

func getStopInformationWithStopId(stopId: NSString, completionHandler: ((NSManagedObject?, NSError?) -> Void)!) -> NSURLSessionDataTask!
{
    // thanks to: http://wongm.com/2014/03/tramtracker-api-dumphone-access/
    let url = NSURL(string: "http://tramtracker.com/Controllers/GetStopInformation.ashx?s=\(stopId)")
    let session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
    let task = session.dataTaskWithURL(url, completionHandler:{
        data, response, error -> Void in
        
        if (error)
        {
            completionHandler(nil, error)
        }
        else if let dict = parseJSON(data)["ResponseObject"] as? NSDictionary
        {
            let stop = NSEntityDescription.insertNewObjectForEntityForName("StopInformation", inManagedObjectContext: CoreDataStore().managedObjectContext) as NSManagedObject
            
            stop.setValue(10, forKey: "stopNo")
            
            //let stop = StopInformation(json: dict)
            completionHandler(stop, nil)
        }
    })
    task.resume()
    
    return task;
}

let stopId = "1234"
let stopInfoTask = getStopInformationWithStopId(stopId, {
    stop, error -> Void in
    
    if (error)
    {
        println("there was an error dowloading stop information for id: \(stopId) error: \(error!.localizedDescription)")
    }
    else if (stop)
    {
        println(stop)
        println("got stop information for id: \(stopId)")
    }
})

XCPSetExecutionShouldContinueIndefinitely(continueIndefinitely: true)
