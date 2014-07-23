
/*
Copyright (C) 2014 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:

Singleton controller to manage the main Core Data stack for the application. It vends a persistent store coordinator, and for convenience the managed object model and URL for the persistent store.

*/


import Foundation
import CoreData


var _sharedInstance: CoreDataStackManager?

public class CoreDataStackManager {
    
    
    public class var sharedInstance: CoreDataStackManager {
        
    if _sharedInstance {
        return _sharedInstance!
        }
        _sharedInstance = CoreDataStackManager()
        return _sharedInstance!
    }
    
    
    /**
    Returns the managed object model for the application.
    */
    public lazy var managedObjectModel: NSManagedObjectModel = {
        let bundle = NSBundle(forClass: CoreDataStackManager.self)
        let modelPath = bundle.pathForResource("NearbyTrams", ofType: "momd")
        let modelURL = NSURL(fileURLWithPath: modelPath)
        return NSManagedObjectModel(contentsOfURL:modelURL)
        }()
    
    
    /**
    Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
    */
    public var persistentStoreCoordinator: NSPersistentStoreCoordinator! {
    
    if _persistentStoreCoordinator {
        return _persistentStoreCoordinator
        }
        
        let url = self.storeURL
        if !url {
            return nil
        }
        
        let mom = self.managedObjectModel
        let psc = NSPersistentStoreCoordinator(managedObjectModel:self.managedObjectModel)
        let options = [NSMigratePersistentStoresAutomaticallyOption : 1, NSInferMappingModelAutomaticallyOption : 1]
        var error: NSError?
        
        if !psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:url, options:options, error:&error) {
            println(error?.localizedDescription)
            fatalError("Could not add the persistent store")
            return nil
        }
        
        _persistentStoreCoordinator = psc
        return _persistentStoreCoordinator
    }
    var _persistentStoreCoordinator: NSPersistentStoreCoordinator?
    
    
    /**
    Returns the URL for the Core Data store file.
    */
    var storeURL: NSURL! {
    
    if _storeURL {
        return _storeURL!
        }
        
        let fileManager = NSFileManager.defaultManager()
        let URLs = fileManager.URLsForDirectory(.ApplicationSupportDirectory, inDomains:.UserDomainMask)
        
        var applicationSupportDirectory = URLs[0] as NSURL
        applicationSupportDirectory = applicationSupportDirectory.URLByAppendingPathComponent("NearbyTrams")
        
        var error: NSError?
        
        let properties = applicationSupportDirectory.resourceValuesForKeys([NSURLIsDirectoryKey!], error:&error)
        
        if properties {
            if !(properties[NSURLIsDirectoryKey] as NSNumber).boolValue {
                let description = NSLocalizedString("Could not access the application data folder.", comment: "Failed to initialize the PSC")
                let reason = NSLocalizedString("Found a file in its place.", comment: "Failed to initialize the PSC")
                let dict = [NSLocalizedDescriptionKey : description, NSLocalizedFailureReasonErrorKey : reason]
                error = NSError.errorWithDomain("CORE_DATA_ERROR_DOMAIN", code:101, userInfo:dict)
                
                println(error?.localizedDescription)
                fatalError("Could not access the application data folder")
                
                
                return nil
            }
        } else {
            var ok = false
            if error!.code == NSFileReadNoSuchFileError {
                ok = fileManager.createDirectoryAtPath(applicationSupportDirectory.path, withIntermediateDirectories:true, attributes:nil, error:&error)
            }
            if !ok {
                println(error?.localizedDescription)
                fatalError("Could not create the application data folder")
                return nil
            }
        }
        
        _storeURL = applicationSupportDirectory.URLByAppendingPathComponent("NearbyTrams.storedata")
        return _storeURL
    }
    var _storeURL: NSURL?
    
}
