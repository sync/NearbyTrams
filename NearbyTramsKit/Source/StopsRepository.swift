//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation
import NearbyTramsStorageKit

public protocol StopsRepositoryDelegate
{
    func stopsRepositoryLoadingStateDidChange(repository: StopsRepository, isLoading loading: Bool) -> Void
    func stopsRepositoryDidFinsishLoading(repository: StopsRepository, error: NSError?) -> Void
}

public class StopsRepository
{
    public var delegate: StopsRepositoryDelegate?
    
    let routeIdentifier: String
    let stopsProvider: StopsProvider
    let managedObjectContext: NSManagedObjectContext
    public var isLoading: Bool {
    willSet {
        self.delegate?.stopsRepositoryLoadingStateDidChange(self, isLoading: newValue)
    }
    }
    
    public init (routeIdentifier: String, stopsProvider: StopsProvider, managedObjectContext: NSManagedObjectContext)
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
    
    public func update() -> Void
    {
        if let route = fetchRoute()
        {
            if let routeNo = route.internalRouteNo as? Int
            {
                self.isLoading = true
                stopsProvider.getStopsWithRouteNo(routeNo, requestStopInfo: true, managedObjectContext: managedObjectContext) {
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
