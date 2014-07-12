//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Cocoa
import LIFXOSX
import NearbyTramsKit
import NearbyTramsStorageKit
import CoreData

class ViewController: NSViewController, NearbyStopsViewControllerModelDelegate, LFXNetworkContextObserver, LFXLightCollectionObserver, LFXLightObserver
{
    let stopsViewModel: StopsViewModel
    let schedulesRepository: SchedulesRepository
    let nearbyStopsViewControllerModel: NearbyStopsViewControllerModel
    
    var schedule: Schedule?
    
    let lifxNetworkContext: LFXNetworkContext
    var lights: LFXLight[]
    
    let managedObjectContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        moc.persistentStoreCoordinator = CoreDataStackManager.sharedInstance.persistentStoreCoordinator
        return moc
        }()
    
    init(coder: NSCoder!)
    {
        let stopsViewModel = StopsViewModel(managedObjectContext: managedObjectContext)
        
        let provider = SchedulesProvider(managedObjectContext: managedObjectContext)
        let schedulesRepository = SchedulesRepository(stopIdentifier: "2166", schedulesProvider: provider, managedObjectContext: managedObjectContext)
        self.nearbyStopsViewControllerModel = NearbyStopsViewControllerModel(viewModel: stopsViewModel, repository: schedulesRepository)
        self.lifxNetworkContext = LFXClient.sharedClient().localNetworkContext
        
        self.stopsViewModel = stopsViewModel
        self.schedulesRepository = schedulesRepository
        self.lights = []

        super.init(coder: coder)
        
        self.nearbyStopsViewControllerModel.delegate = self
        
        self.lifxNetworkContext.addNetworkContextObserver(self)
        self.lifxNetworkContext.allLightsCollection.addLightCollectionObserver(self)
    }
    
    override func viewWillAppear()
    {
        super.viewWillAppear()
        
        self.updateTitle()
        self.updateLights()
    }
    
    func colorForCurrentSchedule(schedule: Schedule?) -> LFXHSBKColor
    {
        // blue
        var color: LFXHSBKColor = LFXHSBKColor(hue: 240, saturation: 0.98, brightness: 1.0)
        
        if let aSchedule = self.schedule
        {
            if let tramDate: NSDate = aSchedule.predictedArrivalDateTime
            {
                let differenceInSeconds = tramDate.timeIntervalSinceNow
                let differenceInMinutes = Int(differenceInSeconds / 60)
                switch differenceInMinutes {
                case 0...2:
                    // red
                    color = LFXHSBKColor(hue: 0, saturation: 0.98, brightness: 1.0)
                case 3...4:
                    // orange
                    color = LFXHSBKColor(hue: 34, saturation: 0.98, brightness: 1.0)
                case 5...7:
                    // green
                    color = LFXHSBKColor(hue: 131, saturation: 0.98, brightness: 1.0)
                default:
                    break
                }
            }
        }
        
        return color
    }
    
    func updateLights()
    {
        if let lights = self.lifxNetworkContext.allLightsCollection.lights as? LFXLight[]
        {
            self.lights = lights
        }
        
        if self.lights.count > 0
        {
            let light = self.lights[0]

            let color = self.colorForCurrentSchedule(self.schedule)
            light.setColor(color)
        }
    }
    
    
    func updateTitle()
    {
        let status = self.lifxNetworkContext.isConnected ? "connected" : "searching"
        self.title = "LIFX Browser \(status)"
    }
    
    // NearbyStopsViewControllerModelDelegate
    func nearbyStopsViewControllerModelDidFinishLoading(nearbyStopsViewControllerModel: NearbyStopsViewControllerModel)
    {
        println("updated schedules")
        
        let fetchRequest = NSFetchRequest(entityName: Schedule.entityName)
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "predictedArrivalDateTime", ascending: true)]
        fetchRequest.predicate = NSPredicate(format:"stop.uniqueIdentifier == %@", "2166")
        
        let schedules = self.managedObjectContext.executeFetchRequest(fetchRequest, error: nil)
        if !schedules.isEmpty
        {
            self.schedule = schedules[0] as? Schedule
            
            if let date: NSDate = schedules[0].predictedArrivalDateTime
            {
                let formattedDate = date.descriptionWithLocale(NSLocale.currentLocale())
                println("next trame is at: \(formattedDate)")
            }
        }
        else
        {
            self.schedule = nil
        }
        
        self.updateLights()
    }
    
    //LFXNetworkContextObserver
    
    func networkContextDidConnect(networkContext: LFXNetworkContext!)
    {
        println("Network Context Did Connect")
        self.updateTitle()
    }
    
    func networkContextDidDisconnect(networkContext: LFXNetworkContext!)
    {
        println("Network Context Did Disconnect")
        self.updateTitle()
    }
    
    func networkContext(networkContext: LFXNetworkContext!, didAddTaggedLightCollection collection: LFXTaggedLightCollection!)
    {
        println("Network Context Did Add Tagged Light Collection: \(collection.tag)")
        collection.addLightCollectionObserver(self)
    }
    
    func networkContext(networkContext: LFXNetworkContext!, didRemoveTaggedLightCollection collection: LFXTaggedLightCollection!)
    {
        println("Network Context Did Add Removed Light Collection: \(collection.tag)")
        collection.removeLightCollectionObserver(self)
    }
    
    // LFXLightCollectionObserver
    
    func lightCollection(lightCollection: LFXLightCollection!, didAddLight light: LFXLight!)
    {
        println("Light Collection: \(lightCollection) Did Add Light: \(light)")
        light.addLightObserver(self)
        self.updateLights()
    }
    
    func lightCollection(lightCollection: LFXLightCollection!, didRemoveLight light: LFXLight!)
    {
        println("Light Collection: \(lightCollection) Did Remove Light: \(light)")
        light.removeLightObserver(self)
        self.updateLights()
    }
    
    // LFXLightObserver
    func light(light: LFXLight!, didChangeLabel label: String!)
    {
        println("Light: \(light) Did Change Label: \(label)");
    }
    
    override var representedObject: AnyObject? {
    didSet {
        // Update the view, if already loaded.
    }
    
    }
}

