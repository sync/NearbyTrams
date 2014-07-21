//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation
import NearbyTramsStorageKit

protocol StopsViewModelDelegate
{
    func stopsViewModelDidAddStops(stopsViewModel: StopsViewModel, stops: StopViewModel[])
    func stopsViewModelDidRemoveStops(stopsViewModel: StopsViewModel, stops: StopViewModel[])
    func stopsViewModelDidUpdateStops(stopsViewModel: StopsViewModel, stops: StopViewModel[])
}

class StopsViewModel: NSObject, SNRFetchedResultsControllerDelegate
{
    var delegate: StopsViewModelDelegate?
    
    let managedObjectContext: NSManagedObjectContext
    
    var fetchedResultsController: SNRFetchedResultsController?
    var stopsStorage: Dictionary<String, StopViewModel> = [ : ]
    var currentChangeSet: FetchedResultsControllerChangeSet?
    var stops: StopViewModel[]
    
    init (managedObjectContext: NSManagedObjectContext)
    {
        self.managedObjectContext = managedObjectContext
        self.stops = []
    }
    
    var stopsCount: Int {
    return stops.count
    }
    
    func stopAtIndex(index: Int) -> StopViewModel
    {
        return self.stops[index]
    }
    
    func startUpdatingStopsWithFetchRequest(fetchRequest: NSFetchRequest)
    {
        self.fetchedResultsController = SNRFetchedResultsController(managedObjectContext: managedObjectContext, fetchRequest: fetchRequest)
        if let currentFetchedResultsController = self.fetchedResultsController
            {
            currentFetchedResultsController.delegate = self
            
            var error: NSError?
            if currentFetchedResultsController.performFetch(&error)
            {
                if let fetchedStops = currentFetchedResultsController.fetchedObjects as? Stop[]
                {
                    synchronizeStopsWithObjectsFromArray(fetchedStops)
                }
            }
            else
            {
                println("Failed to perform fetch stops with request '\(fetchRequest)': \(error)");
            }
        }
    }
    
    func stopUpdatingStops()
    {
        if let currentFetchedResultsController = fetchedResultsController
        {
            currentFetchedResultsController.delegate = nil
            
        }
        self.fetchedResultsController = nil
    }
    
    func existingModelForIdentifier(identifier: String?) -> StopViewModel?
    {
        if let uniqueIdentifier = identifier
        {
            return stopsStorage[uniqueIdentifier]
        }
        
        return nil
    }
    
    func synchronizeStopsWithObjectsFromArray(array: Stop[])
    {
        var stopsByIdentifier: Dictionary<String, Stop> = [ : ]
        for stop in array
        {
            if let identifier = stop.uniqueIdentifier
            {
                stopsByIdentifier[identifier] = stop
            }
        }
        
        var currentIdentifiers = NSSet(array: Array(stopsStorage.keys))
        var newIdentifiers =  NSSet(array: Array(stopsByIdentifier.keys))
        
        let identifiersToAdd = NSMutableSet(set: newIdentifiers)
        identifiersToAdd.minusSet(currentIdentifiers)
        
        let identifiersToRemove = NSMutableSet(set: currentIdentifiers)
        identifiersToRemove.minusSet(newIdentifiers)
        
        let identifiersToUpdate = NSMutableSet(set: currentIdentifiers)
        identifiersToUpdate.intersectSet(newIdentifiers)
        
        if identifiersToAdd.allObjects
        {
            var addedObjects: Stop[] = []
            for identifier : AnyObject in identifiersToAdd.allObjects
            {
                let stop = stopsByIdentifier[identifier as String]
                if stop
                {
                    addedObjects.append(stop!)
                }
            }
            addStopsForObjects(addedObjects)
        }
        
        if identifiersToRemove.allObjects
        {
            var removedStopModels: StopViewModel[] = []
            for identifier : AnyObject in identifiersToRemove.allObjects
            {
                if let stopViewModel = stopsStorage[identifier as String]
                {
                    removedStopModels.append(stopViewModel)
                }
            }
            removeStopModels(removedStopModels)
        }
        
        if identifiersToUpdate.allObjects
        {
            var updatedObjects: Stop[] = []
            for identifier : AnyObject in identifiersToUpdate.allObjects
            {
                if let stop = stopsByIdentifier[identifier as String]
                {
                    updatedObjects.append(stop)
                }
            }
            updateStopsForObjects(updatedObjects)
        }
    }
    
    func addStopsForObjects(array: Stop[])
    {
        if !array.isEmpty
        {
            let stopsViewModel = array.filter {
                stop -> Bool in
                
                return stop.isValidForViewModel
                }.map {
                    stop -> StopViewModel in
                    
                    assert(!self.existingModelForIdentifier(stop.uniqueIdentifier), "stop should not already exist!")
                    
                    let identifier = stop.uniqueIdentifier!
                    let route = stop.route!
                    let viewModel = StopViewModel(identifier: identifier, routeNo: stop.route!.routeNo!, routeDescription: stop.route!.routeDescription!, isUpStop: stop.isUpStop, stopNo: Int(stop.stopNo!), stopName: stop.name!, schedules: stop.nextScheduledArrivalDates)
                    self.stopsStorage[identifier] = viewModel
                    return viewModel
            }
            
            if !stopsViewModel.isEmpty
            {
                didAddStops(stopsViewModel)
            }
        }
    }
    
    func updateStopsForObjects(array: Stop[])
    {
        if !array.isEmpty
        {
            var updatedStops: StopViewModel[] = []
            var deletedStopModels: StopViewModel[] = []
            for stop in array {
                if let existingStopModel = existingModelForIdentifier(stop.uniqueIdentifier)
                {
                    if stop.isValidForViewModel
                    {
                        let route = stop.route!
                        existingStopModel.updateWithRouteNo(stop.route!.routeNo!, routeDescription: stop.route!.routeDescription!, isUpStop: stop.isUpStop, stopNo: Int(stop.stopNo!), stopName: stop.name!, schedules: stop.nextScheduledArrivalDates)
                        updatedStops.append(existingStopModel)
                    }
                    else
                    {
                        deletedStopModels.append(existingStopModel)
                    }
                }
            }
            
            if !deletedStopModels.isEmpty
            {
                removeStopModels(deletedStopModels)
            }
            
            if !updatedStops.isEmpty
            {
                didUpdateStops(updatedStops)
            }
        }
    }
    
    func removeStopModels(array: StopViewModel[])
    {
        if !array.isEmpty
        {
            var removedStops: StopViewModel[] = []
            for stop in array {
                if let existingStopModel = existingModelForIdentifier(stop.identifier)
                {
                    removedStops.append(existingStopModel)
                    stopsStorage.removeValueForKey(existingStopModel.identifier)
                }
            }
            
            if !removedStops.isEmpty
            {
                didRemoveStops(removedStops)
            }
        }
    }
    
    func removeStopsForObjects(array: Stop[])
    {
        if !array.isEmpty
        {
            var removedStopModels: StopViewModel[] = []
            for stop in array {
                if let existingStopModel = existingModelForIdentifier(stop.uniqueIdentifier)
                {
                    removedStopModels.append(existingStopModel)
                }
            }
            
            removeStopModels(removedStopModels)
        }
    }
    
    func didAddStops(stops: StopViewModel[])
    {
        self.stops = Array(stopsStorage.values)
        
        self.delegate?.stopsViewModelDidAddStops(self, stops: stops)
    }
    
    func didRemoveStops(stops: StopViewModel[])
    {
        self.stops = Array(stopsStorage.values)
        
        self.delegate?.stopsViewModelDidRemoveStops(self, stops: stops)
    }
    
    func didUpdateStops(stops: StopViewModel[])
    {
        self.stops = Array(stopsStorage.values)
        
        self.delegate?.stopsViewModelDidUpdateStops(self, stops: stops)
    }
    
    func controllerWillChangeContent(controller: SNRFetchedResultsController!)
    {
        if let changeSet = currentChangeSet
        {
            updateModelWithChangeSet(changeSet)
        }
        
        currentChangeSet = FetchedResultsControllerChangeSet();
    }
    
    func controller(controller: SNRFetchedResultsController!, didChangeObject anObject: AnyObject!, atIndex index: Int, forChangeType type: SNRFetchedResultsChangeType, newIndex: Int)
    {
        if controller == fetchedResultsController
        {
            currentChangeSet?.addChange(FetchedResultsControllerChange(changedObject: anObject, atIndexPath: NSIndexPath(index: index), forChangeType: type, newIndexPath: NSIndexPath(index: newIndex)))
        }
    }
    
    func controllerDidChangeContent(controller: SNRFetchedResultsController!)
    {
        if let changeSet = currentChangeSet
        {
            updateModelWithChangeSet(changeSet)
        }
        
        currentChangeSet = nil
    }
    
    func updateModelWithChangeSet(changeSet: FetchedResultsControllerChangeSet)
    {
        if let addedObjects = changeSet.allAddedObjects as? Stop[]
        {
            addStopsForObjects(addedObjects)
        }
        
        if let updatedObjects = changeSet.allUpdatedObjects as? Stop[]
        {
            updateStopsForObjects(updatedObjects)
        }
        
        if let removedObjects = changeSet.allRemovedObjects as? Stop[]
        {
            removeStopsForObjects(removedObjects)
        }
    }
}

extension Stop
    {
    var isValidForViewModel: Bool {
    return (self.uniqueIdentifier && self.route?.routeNo && self.route?.routeDescription && self.route?.routeNo && self.name && self.route)
    }
}
