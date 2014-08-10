//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation
import NearbyTramsStorageKit

public protocol StopsViewControllerModelDelegate
{
    func stopsViewControllerModelDidUpdateStops(model: StopsViewControllerModel)
}

public class StopsViewControllerModel: NSObject, StopsViewModelDelegate, SchedulesRepositoryDelegate
{
    public var delegate: StopsViewControllerModelDelegate?
    var schedulesRepostiories: Dictionary<String, SchedulesRepository>
    
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
    let provider: SchedulesProvider
    let timer: NSTimer?
    
    public init(viewModel: StopsViewModel, provider: SchedulesProvider, managedObjectContext: NSManagedObjectContext)
    {
        self.viewModel = viewModel
        self.managedObjectContext = managedObjectContext
        self.provider = provider
        self.schedulesRepostiories = [ : ]
        
        super.init()
        
        self.viewModel.delegate = self
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("poll:"), userInfo: nil, repeats: true)
        self.timer?.fire()
    }
    
    deinit
    {
        timer?.invalidate()
    }
    
    func poll(timer: NSTimer!)
    {
        for repository in schedulesRepostiories.values {
            repository.update()
        }
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
        if let routeIdentifier = self.route?.uniqueIdentifier
        {
            for stop in stops
            {
                let schedulesRepository = SchedulesRepository(routeIdentifier:routeIdentifier, stopIdentifier: stop.identifier, schedulesProvider: provider, managedObjectContext: managedObjectContext)
                schedulesRepository.delegate = self
                schedulesRepostiories[stop.identifier] = schedulesRepository
            }
        }
        
        didUpdateStops()
    }
    
    public func stopsViewModelDidUpdateStops(stopsViewModel: StopsViewModel, stops: [StopViewModel])
    {
        didUpdateStops()
    }
    
    public func stopsViewModelDidRemoveStops(stopsViewModel: StopsViewModel, stops: [StopViewModel])
    {
        for stop in stops
        {
            if let schedulesRepository = schedulesRepostiories[stop.identifier]
            {
                schedulesRepository.delegate = nil
                schedulesRepostiories.removeValueForKey(stop.identifier)
            }
        }
        didUpdateStops()
    }
        
    // MARK: SchedulesRepositoryDelegate
    public func schedulesRepositoryLoadingStateDidChange(repository: SchedulesRepository, isLoading loading: Bool) -> Void
    {
        println("schedules are loading: \(loading)")
    }
    
    public func schedulesRepositoryDidFinsishLoading(repository: SchedulesRepository, error: NSError?) -> Void
    {
        println("schedules finished updating")
    }
}
