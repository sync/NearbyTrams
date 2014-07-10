//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation
import NearbyTramsStorageKit

protocol NearbyStopsViewControllerModelDelegate
{
    func nearbyStopsViewControllerModelDidFinishLoading(nearbyStopsViewControllerModel: NearbyStopsViewControllerModel)
}

class NearbyStopsViewControllerModel: NSObject, StopsViewModelDelegate, SchedulesRepositoryDelegate
{
    var delegate: NearbyStopsViewControllerModelDelegate?
    
    let stopsViewModel: StopsViewModel
    let schedulesRepostiory: SchedulesRepository
    
    let timer: NSTimer?
    
    init(viewModel: StopsViewModel, repository: SchedulesRepository)
    {
        self.schedulesRepostiory = repository
        self.stopsViewModel = viewModel
        
        super.init()
        
        self.schedulesRepostiory.delegate = self
        self.stopsViewModel.delegate = self
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("poll:"), userInfo: nil, repeats: true)
        self.timer?.fire()
    }
    
    deinit
    {
        timer?.invalidate()
    }
    
    func poll(timer: NSTimer!)
    {
        self.schedulesRepostiory.update()
    }
    
    // StopsViewModelDelegate
    func stopsViewModelDidAddStops(stopsViewModel: StopsViewModel, stops: StopViewModel[])
    {
        
    }
    
    func stopsViewModelDidRemoveStops(stopsViewModel: StopsViewModel, stops: StopViewModel[])
    {
        
    }
    
    func stopsViewModelDidUpdateStops(stopsViewModel: StopsViewModel, stops: StopViewModel[])
    {
        
    }
        
    // SchedulesRepositoryDelegate
    func schedulesRepositoryLoadingStateDidChange(repository: SchedulesRepository, isLoading loading: Bool) -> Void
    {
        println("schedules are loading: \(loading)")
    }
    
    func schedulesRepositoryDidFinsishLoading(repository: SchedulesRepository, error: NSError?) -> Void
    {
        println("schedules finished updating")
        
        self.delegate?.nearbyStopsViewControllerModelDidFinishLoading(self)
    }
}
