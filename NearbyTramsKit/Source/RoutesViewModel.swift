//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation
import NearbyTramsStorageKit

protocol RoutesViewModelDelegate
{
    func routesViewModelDidAddRoutes(routesViewModel: RoutesViewModel, routes: RouteViewModel[])
    func routesViewModelDidRemoveRoutes(routesViewModel: RoutesViewModel, routes: RouteViewModel[])
    func routesViewModelDidUpdateRoutes(routesViewModel: RoutesViewModel, routes: RouteViewModel[])
}

class RoutesViewModel: NSObject, SNRFetchedResultsControllerDelegate
{
    var delegate: RoutesViewModelDelegate?
    
    let managedObjectContext: NSManagedObjectContext
    
    var fetchedResultsController: SNRFetchedResultsController?
    var routesStorage: Dictionary<String, RouteViewModel> = [ : ]
    var currentChangeSet: FetchedResultsControllerChangeSet?
    
    init (managedObjectContext: NSManagedObjectContext)
    {
        self.managedObjectContext = managedObjectContext
    }
    
    var orderedRouteIdentifiers: String[] {
    let orderedIdentifiers = self.fetchedResultsController?.fetchedObjects.filter {
        route -> Bool in
        
        if let uniqueIdentifier = route.uniqueIdentifier as? NSString
        {
            return self.routesStorage.indexForKey(uniqueIdentifier) != nil
        }
        
        return false
        }.map {
            route -> String in
            
            return route.uniqueIdentifier!
        }
        
        return orderedIdentifiers ? orderedIdentifiers! : []
    }
    
    var routes: RouteViewModel[] {
    return self.orderedRouteIdentifiers.filter {
        identifier -> Bool in
        
        self.routesStorage.indexForKey(identifier) != nil
        }.map {
            identifier -> RouteViewModel in
            
            return  self.routesStorage[identifier]!
        }
    }
    
    var routesCount: Int {
    return self.routes.count
    }
    
    func routeAtIndex(index: Int) -> RouteViewModel
    {
        return self.routes[index]
    }
    
    func startUpdatingRoutesWithFetchRequest(fetchRequest: NSFetchRequest)
    {
        let currentFetchedResultsController = SNRFetchedResultsController(managedObjectContext: managedObjectContext, fetchRequest: fetchRequest)
        currentFetchedResultsController.delegate = self
        
        var error: NSError?
        if currentFetchedResultsController.performFetch(&error)
        {
            if let fetchedRoutes = currentFetchedResultsController.fetchedObjects as? Route[]
            {
                synchronizeRoutesWithObjectsFromArray(fetchedRoutes)
            }
        }
        else
        {
            println("Failed to perform fetch routes with request '\(fetchRequest)': \(error)");
        }
        
        self.fetchedResultsController = currentFetchedResultsController
    }
    
    func stopUpdatingRoutes()
    {
        if let currentFetchedResultsController = fetchedResultsController
        {
            currentFetchedResultsController.delegate = nil
            
        }
        self.fetchedResultsController = nil
    }
    
    func existingModelForRoute(route: Route) -> RouteViewModel?
    {
        if let identifier = route.uniqueIdentifier
        {
            return routesStorage[identifier]
        }
        
        return nil
    }
    
    func synchronizeRoutesWithObjectsFromArray(array: Route[])
    {
        var routesByIdentifier: Dictionary<String, Route> = [ : ]
        for route in array
        {
            if let identifier = route.uniqueIdentifier
            {
                routesByIdentifier[identifier] = route
            }
        }
        
        var currentIdentifiers = NSSet(array: Array(routesStorage.keys))
        var newIdentifiers =  NSSet(array: Array(routesByIdentifier.keys))
        
        let identifiersToAdd = NSMutableSet(set: newIdentifiers)
        identifiersToAdd.minusSet(currentIdentifiers)
        
        let identifiersToRemove = NSMutableSet(set: currentIdentifiers)
        identifiersToRemove.minusSet(newIdentifiers)
        
        let identifiersToUpdate = NSMutableSet(set: currentIdentifiers)
        identifiersToUpdate.intersectSet(newIdentifiers)
        
        if identifiersToAdd.allObjects
        {
            var addedObjects: Route[] = []
            for identifier : AnyObject in identifiersToAdd.allObjects
            {
                let route = routesByIdentifier[identifier as String]
                if route
                {
                    addedObjects.append(route!)
                }
            }
            addRoutesForObjects(addedObjects)
        }
        
        if identifiersToRemove.allObjects
        {
            var removedObjects: Route[] = []
            for identifier : AnyObject in identifiersToRemove.allObjects
            {
                let routeViewModel = routesStorage[identifier as String]
                if routeViewModel
                {
                    var result: (route: Route?, error:NSError?) = Route.fetchOneForPrimaryKeyValue(routeViewModel!.identifier, usingManagedObjectContext: managedObjectContext)
                    if let route = result.route
                    {
                        removedObjects.append(route)
                    }
                }
            }
            removeRoutesForObjects(removedObjects)
        }
        
        if identifiersToUpdate.allObjects
        {
            var updatedObjects: Route[] = []
            for identifier : AnyObject in identifiersToUpdate.allObjects
            {
                let route = routesByIdentifier[identifier as String]
                if route
                {
                    updatedObjects.append(route!)
                }
            }
            updateRoutesForObjects(updatedObjects)
        }
    }
    
    func addRoutesForObjects(array: Route[])
    {
        if !array.isEmpty
        {
            let routesViewModel = array.filter {
                route -> Bool in
                
                return route.isValidForViewModel
                }.map {
                    route -> RouteViewModel in
                    
                    assert(!self.existingModelForRoute(route), "route should not already exist!")
                    
                    let identifier = route.uniqueIdentifier!
                    let viewModel = RouteViewModel(identifier: identifier, routeNo: route.routeNo!, routeDescription: route.routeDescription!, downDestination: route.downDestination!, upDestination: route.upDestination!)
                    self.routesStorage[identifier] = viewModel
                    return viewModel
            }
            
            if !routesViewModel.isEmpty
            {
                didAddRoutes(routesViewModel)
            }
        }
    }
    
    func updateRoutesForObjects(array: Route[])
    {
        if !array.isEmpty
        {
            var updatedRoutes: RouteViewModel[] = []
            var deletedRoutes: Route[] = []
            for route in array {
                if let existingRouteModel = existingModelForRoute(route)
                {
                    if route.isValidForViewModel
                    {
                        existingRouteModel.updateWithRouteNo(route.routeNo!, routeDescription: route.routeDescription!, downDestination: route.downDestination!, upDestination: route.upDestination!)
                        updatedRoutes.append(existingRouteModel)
                    }
                    else
                    {
                        deletedRoutes.append(route)
                    }
                }
            }
            
            if !deletedRoutes.isEmpty
            {
                removeRoutesForObjects(deletedRoutes)
            }
            
            if !updatedRoutes.isEmpty
            {
                didUpdateRoutes(updatedRoutes)
            }
        }
    }
    
    func removeRoutesForObjects(array: Route[])
    {
        if !array.isEmpty
        {
            var removedRoutes: RouteViewModel[] = []
            for route in array {
                if let existingRouteModel = existingModelForRoute(route)
                {
                    removedRoutes.append(existingRouteModel)
                    routesStorage.removeValueForKey(existingRouteModel.identifier)
                }
            }
            
            if !removedRoutes.isEmpty
            {
                didRemoveRoutes(removedRoutes)
            }
        }
    }
    
    func didAddRoutes(routes: RouteViewModel[])
    {
        self.delegate?.routesViewModelDidAddRoutes(self, routes: routes)
    }
    
    func didRemoveRoutes(routes: RouteViewModel[])
    {
        self.delegate?.routesViewModelDidRemoveRoutes(self, routes: routes)
    }
    
    func didUpdateRoutes(routes: RouteViewModel[])
    {
        self.delegate?.routesViewModelDidUpdateRoutes(self, routes: routes)
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
        if let addedObjects = changeSet.allAddedObjects as? Route[]
        {
            addRoutesForObjects(addedObjects)
        }
        
        if let updatedObjects = changeSet.allUpdatedObjects as? Route[]
        {
            updateRoutesForObjects(updatedObjects)
        }
        
        if let removedObjects = changeSet.allRemovedObjects as? Route[]
        {
            removeRoutesForObjects(removedObjects)
        }
    }
}

extension Route
    {
    var isValidForViewModel: Bool {
    return (self.uniqueIdentifier && self.routeNo && self.routeDescription && self.downDestination && self.upDestination)
    }
}
