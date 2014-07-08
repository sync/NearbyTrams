//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation
import NearbyTramsStorageKit

protocol StopsRepositoryDelegate
{
    func stopsRepositoryLoadingStateDidChange(repository: StopsRepository, isLoading loading: Bool) -> Void
    func stopsRepositoryDidFinsishLoading(repository: StopsRepository, error: NSError?) -> Void
}

class StopsRepository
{
    var delegate: StopsRepositoryDelegate?
    
    let routeIdentifier: String
    let stopsProvider: StopsProvider
    let managedObjectContext: NSManagedObjectContext
    var isLoading: Bool {
    willSet {
        self.delegate?.stopsRepositoryLoadingStateDidChange(self, isLoading: newValue)
    }
    }
    
    init (routeIdentifier: String, stopsProvider: StopsProvider, managedObjectContext: NSManagedObjectContext)
    {
        self.routeIdentifier = routeIdentifier
        self.stopsProvider = stopsProvider
        self.managedObjectContext = managedObjectContext
        self.isLoading = false
    }
    
    func fetchRoute() -> Route?
    {
        let result: (managedObject: Route?, error: NSError?) = Route.fetchOneForPrimaryKeyValue(self.routeIdentifier, usingManagedObjectContext: self.managedObjectContext)
        return result.managedObject
    }
    
    func update() -> Void
    {
        if let route = fetchRoute()
        {
            if let routeNo = route.routeNo as? Int
            {
                self.isLoading = true
                stopsProvider.getStopsWithRouteNo(routeNo, isUpDestination: route.isUpDestination, requestStopInfo: true, managedObjectContext: managedObjectContext) {
                    stopObjectIds, error -> Void in
                    
                    if let objectIds = stopObjectIds
                    {
                        let result: (stops: [Stop]?, error:NSError?) = Stop.fetchAllForManagedObjectIds(objectIds, usingManagedObjectContext: self.managedObjectContext)
                        if let stops = result.stops
                        {
                            route.stops = NSMutableSet(array: stops)
                            self.managedObjectContext.save(nil)
                        }
                    }
                    
                    self.isLoading = false
                    self.delegate?.stopsRepositoryDidFinsishLoading(self, error: error)
                }
            }
        }
    }
}
