//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation
import NearbyTramsStorageKit

public protocol StopsViewModelDelegate
{
    func stopsViewModelDidAddStops(stopsViewModel: StopsViewModel, stops: [StopViewModel])
    func stopsViewModelDidRemoveStops(stopsViewModel: StopsViewModel, stops: [StopViewModel])
    func stopsViewModelDidUpdateStops(stopsViewModel: StopsViewModel, stops: [StopViewModel])
}

public class StopsViewModel: NSObject, SNRFetchedResultsControllerDelegate
{
    public var delegate: StopsViewModelDelegate?
    
    let managedObjectContext: NSManagedObjectContext
    
    var fetchedResultsController: SNRFetchedResultsController?
    var stopsStorage: Dictionary<String, StopViewModel> = [ : ]
    var currentChangeSet: FetchedResultsControllerChangeSet?
    public var stops: [StopViewModel]
    
    public init (managedObjectContext: NSManagedObjectContext)
    {
        self.managedObjectContext = managedObjectContext
        self.stops = []
    }
    
    public var stopsCount: Int {
    return stops.count
    }
    
    public func stopAtIndex(index: Int) -> StopViewModel
    {
        return self.stops[index]
    }
    
    public func startUpdatingStopsWithFetchRequest(fetchRequest: NSFetchRequest)
    {
        var currentFetchedObjects = self.fetchedResultsController?.fetchedObjects
        if let currentStops = currentFetchedObjects as? [Stop]
        {
            removeStopsForObjects(currentStops)
        }
        
        self.fetchedResultsController = SNRFetchedResultsController(managedObjectContext: managedObjectContext, fetchRequest: fetchRequest)
        if let currentFetchedResultsController = self.fetchedResultsController
        {
            currentFetchedResultsController.delegate = self
            
            var error: NSError?
            if currentFetchedResultsController.performFetch(&error)
            {
                if let fetchedStops = currentFetchedResultsController.fetchedObjects as? [Stop]
                {
                   addStopsForObjects(fetchedStops)
                }
            }
            else
            {
                println("Failed to perform fetch stops with request '\(fetchRequest)': \(error)");
            }
        }
    }
    
    public func stopUpdatingStops()
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
    
    func addStopsForObjects(array: [Stop])
    {
        let stopsViewModel = array.map {
            stop -> StopViewModel in
            
            assert(!self.existingModelForIdentifier(stop.uniqueIdentifier), "stop should not already exist!")
            
            let identifier = stop.uniqueIdentifier!
            let viewModel = StopViewModel(identifier: identifier, routesNo: stop.routesNo, stopDescription: stop.stopDescription!, isUpStop: stop.isUpStop, stopNo: Int(stop.stopNo!), stopName: stop.name!, schedules: stop.nextScheduledArrivalDates)
            self.stopsStorage[identifier] = viewModel
            return viewModel
        }
        
        if !stopsViewModel.isEmpty
        {
            didAddStops(stopsViewModel)
        }
    }
    
    func updateStopsForObjects(array: [Stop])
    {
        if !array.isEmpty
        {
            var updatedStops: [StopViewModel] = []
            var deletedStopModels: [StopViewModel] = []
            for stop in array {
                if let existingStopModel = existingModelForIdentifier(stop.uniqueIdentifier)
                {
                    existingStopModel.updateWithRoutesNo(stop.routesNo, stopDescription: stop.stopDescription!, isUpStop: stop.isUpStop, stopNo: Int(stop.stopNo!), stopName: stop.name!, schedules: stop.nextScheduledArrivalDates)
                    updatedStops.append(existingStopModel)
                }
            }
            
            if !updatedStops.isEmpty
            {
                didUpdateStops(updatedStops)
            }
        }
    }
    
    func removeStopsForObjects(array: [Stop])
    {
        var removedStops: [StopViewModel] = []
        for stop in array {
            if let existingStopModel = existingModelForIdentifier(stop.uniqueIdentifier)
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
    
    func didAddStops(stops: [StopViewModel])
    {
        self.stops = Array(stopsStorage.values)
        
        self.delegate?.stopsViewModelDidAddStops(self, stops: stops)
    }
    
    func didRemoveStops(stops: [StopViewModel])
    {
        self.stops = Array(stopsStorage.values)
        
        self.delegate?.stopsViewModelDidRemoveStops(self, stops: stops)
    }
    
    func didUpdateStops(stops: [StopViewModel])
    {
        self.stops = Array(stopsStorage.values)
        
        self.delegate?.stopsViewModelDidUpdateStops(self, stops: stops)
    }
    
    public func controllerWillChangeContent(controller: SNRFetchedResultsController!)
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
    
    public func controllerDidChangeContent(controller: SNRFetchedResultsController!)
    {
        if let changeSet = currentChangeSet
        {
            updateModelWithChangeSet(changeSet)
        }
        
        currentChangeSet = nil
    }
    
    func updateModelWithChangeSet(changeSet: FetchedResultsControllerChangeSet)
    {
        if let addedObjects = changeSet.allAddedObjects as? [Stop]
        {
            addStopsForObjects(addedObjects)
        }
        
        if let updatedObjects = changeSet.allUpdatedObjects as? [Stop]
        {
            updateStopsForObjects(updatedObjects)
        }
        
        if let removedObjects = changeSet.allRemovedObjects as? [Stop]
        {
            removeStopsForObjects(removedObjects)
        }
    }
}
