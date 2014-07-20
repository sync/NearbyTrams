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
    
    init (managedObjectContext: NSManagedObjectContext)
    {
        self.managedObjectContext = managedObjectContext
    }
    
    var orderedStopIdentifiers: String[] {
    let orderedIdentifiers = self.fetchedResultsController?.fetchedObjects.filter {
        stop -> Bool in
        
        if let uniqueIdentifier = stop.uniqueIdentifier as? NSString
        {
            return self.stopsStorage.indexForKey(uniqueIdentifier) != nil
        }
        
        return false
        }.map {
            stop -> String in
            
            return stop.uniqueIdentifier!
        }
        
        return orderedIdentifiers ? orderedIdentifiers! : []
    }
    
    var stops: StopViewModel[] {
    return self.orderedStopIdentifiers.filter {
        identifier -> Bool in
        
        self.stopsStorage.indexForKey(identifier) != nil
        }.map {
            identifier -> StopViewModel in
            
            return  self.stopsStorage[identifier]!
        }
    }
    
    var stopsCount: Int {
    return stops.count
    }
    
    func startUpdatingStopsWithFetchRequest(fetchRequest: NSFetchRequest)
    {
        let currentFetchedResultsController = SNRFetchedResultsController(managedObjectContext: managedObjectContext, fetchRequest: fetchRequest)
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
        
        self.fetchedResultsController = currentFetchedResultsController
    }
    
    func stopUpdatingStops()
    {
        if let currentFetchedResultsController = fetchedResultsController
        {
            currentFetchedResultsController.delegate = nil
            
        }
        self.fetchedResultsController = nil
    }
    
    func existingModelForStop(stop: Stop) -> StopViewModel?
    {
        if let identifier = stop.uniqueIdentifier
        {
            return stopsStorage[identifier]
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
            var removedObjects: Stop[] = []
            for identifier : AnyObject in identifiersToRemove.allObjects
            {
                let stopViewModel = stopsStorage[identifier as String]
                if stopViewModel
                {
                    var result: (stop: Stop?, error:NSError?) = Stop.fetchOneForPrimaryKeyValue(stopViewModel!.identifier, usingManagedObjectContext: managedObjectContext)
                    if let stop = result.stop
                    {
                        removedObjects.append(stop)
                    }
                }
            }
            removeStopsForObjects(removedObjects)
        }
        
        if identifiersToUpdate.allObjects
        {
            var updatedObjects: Stop[] = []
            for identifier : AnyObject in identifiersToUpdate.allObjects
            {
                let stop = stopsByIdentifier[identifier as String]
                if stop
                {
                    updatedObjects.append(stop!)
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
                    
                    assert(!self.existingModelForStop(stop), "stop should not already exist!")
                    
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
            var deletedStops: Stop[] = []
            for stop in array {
                if let existingStopModel = existingModelForStop(stop)
                {
                    if stop.isValidForViewModel
                    {
                        let route = stop.route!
                        existingStopModel.updateWithRouteNo(stop.route!.routeNo!, routeDescription: stop.route!.routeDescription!, isUpStop: stop.isUpStop, stopNo: Int(stop.stopNo!), stopName: stop.name!, schedules: stop.nextScheduledArrivalDates)
                        updatedStops.append(existingStopModel)
                    }
                    else
                    {
                        deletedStops.append(stop)
                    }
                }
            }
            
            if !deletedStops.isEmpty
            {
                removeStopsForObjects(deletedStops)
            }
            
            if !updatedStops.isEmpty
            {
                didUpdateStops(updatedStops)
            }
        }
    }
    
    func removeStopsForObjects(array: Stop[])
    {
        if !array.isEmpty
        {
            var removedStops: StopViewModel[] = []
            for stop in array {
                if let existingStopModel = existingModelForStop(stop)
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
    
    func didAddStops(stops: StopViewModel[])
    {
        self.delegate?.stopsViewModelDidAddStops(self, stops: stops)
    }
    
    func didRemoveStops(stops: StopViewModel[])
    {
        self.delegate?.stopsViewModelDidRemoveStops(self, stops: stops)
    }
    
    func didUpdateStops(stops: StopViewModel[])
    {
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
