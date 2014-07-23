//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation
import NearbyTramsStorageKit

public protocol RoutesViewControllerModelDelegate
{
    func routesViewControllerModelDidUpdateRoutes(model: RoutesViewControllerModel)
}

public class RoutesViewControllerModel: NSObject, RoutesViewModelDelegate
{
    let viewModel: RoutesViewModel
    
    public var delegate: RoutesViewControllerModelDelegate?
    
    public init(viewModel: RoutesViewModel)
    {
        self.viewModel = viewModel
        
        super.init()
        
        self.viewModel.delegate = self
        
        let fetchRequest = NSFetchRequest(entityName: Route.entityName)
        
        let routeNoDescriptor = NSSortDescriptor(key: "routeNo", ascending: true, selector: Selector("localizedStandardCompare:"))
        fetchRequest.sortDescriptors = [routeNoDescriptor]
        viewModel.startUpdatingRoutesWithFetchRequest(fetchRequest)
    }
    
    public var routesCount: Int {
    return self.viewModel.routesCount
    }
    
    public func routeAtIndex(index: Int) -> RouteViewModel
    {
        return self.viewModel.routeAtIndex(index)
    }
    
    func didUpdateRoutes()
    {
        self.delegate?.routesViewControllerModelDidUpdateRoutes(self)
    }
    
    // RoutesViewModelDelegate
    public func routesViewModelDidAddRoutes(routesViewModel: RoutesViewModel, routes: [RouteViewModel])
    {
        didUpdateRoutes()
    }
    
    public func routesViewModelDidRemoveRoutes(routesViewModel: RoutesViewModel, routes: [RouteViewModel])
    {
        didUpdateRoutes()
    }
    
    public func routesViewModelDidUpdateRoutes(routesViewModel: RoutesViewModel, routes: [RouteViewModel])
    {
        didUpdateRoutes()
    }
}
