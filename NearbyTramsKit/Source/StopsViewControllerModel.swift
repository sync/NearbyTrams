//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation
import NearbyTramsStorageKit

public protocol StopsViewControllerModelDelegate
{
    func stopsViewControllerModelDidUpdateStops(model: StopsViewControllerModel)
}

public class StopsViewControllerModel: NSObject, StopsViewModelDelegate
{
    public var delegate: StopsViewControllerModelDelegate?
    
    public var route: Route? {
    didSet {
        if route.hasValue
        {
            let fetchRequest = NSFetchRequest(entityName: Stop.entityName)
            fetchRequest.predicate = NSPredicate(format:"routes CONTAINS %@ AND uniqueIdentifier != nil AND ANY routes.routeNo != nil AND stopDescription != nil AND stopNo != nil AND name != nil", route!)
            viewModel.startUpdatingStopsWithFetchRequest(fetchRequest)
        }
        else
        {
            viewModel.stopUpdatingStops()
        }
    }
    }
    
    let viewModel: StopsViewModel
    let managedObjectContext: NSManagedObjectContext
    
    public init(viewModel: StopsViewModel, managedObjectContext: NSManagedObjectContext)
    {
        self.viewModel = viewModel
        self.managedObjectContext = managedObjectContext
        
        super.init()
        
        self.viewModel.delegate = self
    }
    
    public var stopsCount: Int {
    return self.viewModel.stopsCount
    }
    
    public func stopAtIndex(index: Int) -> StopViewModel
    {
        return self.viewModel.stopAtIndex(index)
    }
    
    func didUpdateStops()
    {
        self.delegate?.stopsViewControllerModelDidUpdateStops(self)
    }
    
    // MARK: StopsViewModelDelegate
    public func stopsViewModelDidAddStops(stopsViewModel: StopsViewModel, stops: [StopViewModel])
    {
        didUpdateStops()
    }
    
    public func stopsViewModelDidUpdateStops(stopsViewModel: StopsViewModel, stops: [StopViewModel])
    {
        didUpdateStops()
    }
    
    public func stopsViewModelDidRemoveStops(stopsViewModel: StopsViewModel, stops: [StopViewModel])
    {
        didUpdateStops()
    }
}
