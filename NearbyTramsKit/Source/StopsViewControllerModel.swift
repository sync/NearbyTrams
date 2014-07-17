//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation
import NearbyTramsStorageKit

protocol StopsViewControllerModelDelegate
{
    func stopsViewControllerModelDidFinishLoading(stopsViewControllerModel: StopsViewControllerModel, stopIdentifier: String)
}

class StopsViewControllerModel: NSObject, StopsViewModelDelegate, SchedulesRepositoryDelegate
{
    var delegate: StopsViewControllerModelDelegate?
    var schedulesRepostiories: Dictionary<String, SchedulesRepository>
    
    let stopsViewModel: StopsViewModel
    let managedObjectContext: NSManagedObjectContext
    let provider: SchedulesProvider
    let timer: NSTimer?
    
    init(viewModel: StopsViewModel, provider: SchedulesProvider, managedObjectContext: NSManagedObjectContext)
    {
        self.stopsViewModel = viewModel
        self.managedObjectContext = managedObjectContext
        self.provider = provider
        self.schedulesRepostiories = [ : ]
        
        super.init()
        
        self.stopsViewModel.delegate = self
        
        let fetchRequest = NSFetchRequest(entityName: Stop.entityName)
        fetchRequest.predicate = NSPredicate(format:"uniqueIdentifier == %@", "2166")
        viewModel.startUpdatingStopsWithFetchRequest(fetchRequest)
        
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
    
    // StopsViewModelDelegate
    func stopsViewModelDidAddStops(stopsViewModel: StopsViewModel, stops: StopViewModel[])
    {
        for stop in stops
        {
            let schedulesRepository = SchedulesRepository(stopIdentifier: stop.identifier, schedulesProvider: provider, managedObjectContext: managedObjectContext)
            schedulesRepository.delegate = self
            schedulesRepostiories[stop.identifier] = schedulesRepository
        }
    }
    
    func stopsViewModelDidUpdateStops(stopsViewModel: StopsViewModel, stops: StopViewModel[])
    {
        
    }
    
    func stopsViewModelDidRemoveStops(stopsViewModel: StopsViewModel, stops: StopViewModel[])
    {
        for stop in stops
        {
            if let schedulesRepository = schedulesRepostiories[stop.identifier]
            {
                schedulesRepository.delegate = nil
                schedulesRepostiories.removeValueForKey(stop.identifier)
            }
        }
    }
        
    // SchedulesRepositoryDelegate
    func schedulesRepositoryLoadingStateDidChange(repository: SchedulesRepository, isLoading loading: Bool) -> Void
    {
        println("schedules are loading: \(loading)")
    }
    
    func schedulesRepositoryDidFinsishLoading(repository: SchedulesRepository, error: NSError?) -> Void
    {
        println("schedules finished updating")
        
        self.delegate?.stopsViewControllerModelDidFinishLoading(self, stopIdentifier: repository.stopIdentifier)
    }
}
