//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

public protocol RoutesRepositoryDelegate
{
    func routesRepositoryLoadingStateDidChange(repository: RoutesRepository, isLoading loading: Bool) -> Void
    func routesRepositoryDidFinsishLoading(repository: RoutesRepository, error: NSError?) -> Void
}

public class RoutesRepository
{
    public var delegate: RoutesRepositoryDelegate?
    
    let routesProvider: RoutesProvider
    let managedObjectContext: NSManagedObjectContext
    public var isLoading: Bool {
    willSet {
        self.delegate?.routesRepositoryLoadingStateDidChange(self, isLoading: newValue)
    }
    }
    
    public init (routesProvider: RoutesProvider, managedObjectContext: NSManagedObjectContext)
    {
        self.routesProvider = routesProvider
        self.managedObjectContext = managedObjectContext
        self.isLoading = false
    }
    
    public func update() -> Void
    {
        self.isLoading = true
        routesProvider.getAllRoutesWithManagedObjectContext(managedObjectContext) {
            routeObjectIds, error -> Void in
            
            self.isLoading = false
            self.delegate?.routesRepositoryDidFinsishLoading(self, error: error)
        }
    }
}
