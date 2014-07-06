// Playground - noun: a place where people can play

import XCPlayground
import Cocoa
import CoreData

class CoreDataStore
{
    @lazy var managedObjectContext: NSManagedObjectContext = {
        
        let modelURL = NSBundle.mainBundle().URLForResource("NearbyTrams", withExtension: "momd")
        let managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)
        
        var error: NSError? = nil
        let persistentStoreCoordinator:NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        if persistentStoreCoordinator.addPersistentStoreWithType(NSInMemoryStoreType,
            configuration: nil,
            URL: nil,
            options: nil,
            error: &error) == nil
        {
            println("there was an error loading in memory core data tests store: \(error!.localizedDescription)")
            abort()
        }
        
        let _managedObjectContext = NSManagedObjectContext()
        _managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        
        return _managedObjectContext
        }()
}

func parseJSON(inputData: NSData) -> NSDictionary
{
    var dictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
    
    return dictionary
}

func getStopInformationWithStopNo(stopNo: Int, completionHandler: ((NSManagedObject?, NSError?) -> Void)!) -> NSURLSessionDataTask!
{
    // thanks to: http://wongm.com/2014/03/tramtracker-api-dumphone-access/
    let url = NSURL(string: "http://tramtracker.com/Controllers/GetStopInformation.ashx?s=\(stopNo)")
    let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    let task = session.dataTaskWithURL(url, completionHandler:{
        data, response, error -> Void in
        
        if (error)
        {
            completionHandler(nil, error)
        }
        else if let dict = parseJSON(data)["ResponseObject"] as? NSDictionary
        {
            let stop = NSEntityDescription.insertNewObjectForEntityForName("Stop", inManagedObjectContext: CoreDataStore().managedObjectContext) as NSManagedObject
            
            stop.setValue(10, forKey: "stopNo")
            
            //let stop = Stop(json: dict)
            completionHandler(stop, nil)
        }
    })
    task.resume()
    
    return task
}

let stopNo = 1234
let stopInfoTask = getStopInformationWithStopNo(stopNo, {
    stop, error -> Void in
    
    if (error)
    {
        println("there was an error dowloading stop information for id: \(stopNo) error: \(error!.localizedDescription)")
    }
    else if (stop)
    {
        println(stop)
        println("got stop information for id: \(stopNo)")
    }
})

let randomCGColor = CGColorCreateGenericRGB(CGFloat(arc4random_uniform(255)) / 255.0, CGFloat(arc4random_uniform(255)) / 255.0, CGFloat(arc4random_uniform(255)) / 255.0, 0.5)
let color = NSColor(CGColor: x)

XCPSetExecutionShouldContinueIndefinitely(continueIndefinitely: true)
