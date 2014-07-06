//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

protocol StopsRepositoryDelegate
{
    func stopsRepositoryLoadingStateDidChange(repository: StopsRepository, isLoading loading: Bool) -> Void
    func stopsRepositoryDidFinsishLoading(repository: StopsRepository, error: NSError?) -> Void
}

class StopsRepository
{
    var delegate: StopsRepositoryDelegate?
    
    let routeNo: Int
    let stopsProvider: StopsProvider
    let managedObjectContext: NSManagedObjectContext
    var isLoading: Bool {
    willSet {
        self.delegate?.stopsRepositoryLoadingStateDidChange(self, isLoading: newValue)
    }
    }
    
    init (routeNo: Int, stopsProvider: StopsProvider, managedObjectContext: NSManagedObjectContext)
    {
        self.routeNo = routeNo
        self.stopsProvider = stopsProvider
        self.managedObjectContext = managedObjectContext
        self.isLoading = false
    }
    
    func update() -> Void
    {
        self.isLoading = true
        stopsProvider.getStopsWithRouteNo(routeNo, requestStopInfo: true, managedObjectContext: managedObjectContext) {
            stopObjectIds, error -> Void in
            
            self.isLoading = false
            self.delegate?.stopsRepositoryDidFinsishLoading(self, error: error)
        }
    }
}
