//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation
import NearbyTramsStorageKit

protocol RoutesViewControllerModelDelegate
{
    func routesViewControllerModelDidUpdateRoutes(model: RoutesViewControllerModel)
}

class RoutesViewControllerModel: NSObject, RoutesViewModelDelegate
{
    let viewModel: RoutesViewModel
    
    var delegate: RoutesViewControllerModelDelegate?
    
    init(viewModel: RoutesViewModel)
    {
        self.viewModel = viewModel
        
        super.init()
        
        self.viewModel.delegate = self
        
        let fetchRequest = NSFetchRequest(entityName: Route.entityName)
        
        let routeNoDescriptor = NSSortDescriptor(key: "routeNo", ascending: true, selector: Selector("localizedStandardCompare:"))
        fetchRequest.sortDescriptors = [routeNoDescriptor]
        viewModel.startUpdatingRoutesWithFetchRequest(fetchRequest)
    }
    
    var routesCount: Int {
    return self.viewModel.routesCount
    }
    
    func routeAtIndex(index: Int) -> RouteViewModel
    {
        return self.viewModel.routeAtIndex(index)
    }
    
    // RoutesViewModelDelegate
    func routesViewModelDidAddRoutes(routesViewModel: RoutesViewModel, routes: RouteViewModel[])
    {
        self.delegate?.routesViewControllerModelDidUpdateRoutes(self)
    }
    
    func routesViewModelDidRemoveRoutes(routesViewModel: RoutesViewModel, routes: RouteViewModel[])
    {
        self.delegate?.routesViewControllerModelDidUpdateRoutes(self)
    }
    
    func routesViewModelDidUpdateRoutes(routesViewModel: RoutesViewModel, routes: RouteViewModel[])
    {
        self.delegate?.routesViewControllerModelDidUpdateRoutes(self)
    }
}
