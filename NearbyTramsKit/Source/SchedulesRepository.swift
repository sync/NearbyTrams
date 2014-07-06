//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

protocol SchedulesRepositoryDelegate
{
    func schedulesRepositoryLoadingStateDidChange(repository: SchedulesRepository, isLoading loading: Bool) -> Void
    func schedulesRepositoryDidFinsishLoading(repository: SchedulesRepository, error: NSError?) -> Void
}

class SchedulesRepository
{
    var delegate: SchedulesRepositoryDelegate?
    
    let stopNo: Int
    let schedulesProvider: SchedulesProvider
    let managedObjectContext: NSManagedObjectContext
    var isLoading: Bool {
    willSet {
        self.delegate?.schedulesRepositoryLoadingStateDidChange(self, isLoading: newValue)
    }
    }
    
    init (stopNo: Int, schedulesProvider: SchedulesProvider, managedObjectContext: NSManagedObjectContext)
    {
        self.stopNo = stopNo
        self.schedulesProvider = schedulesProvider
        self.managedObjectContext = managedObjectContext
        self.isLoading = false
    }
    
    func update() -> Void
    {
        self.isLoading = true
        schedulesProvider.getNextPredictionsWithStopNo(stopNo, managedObjectContext: managedObjectContext) {
            scheduleObjectIds, error -> Void in
            
            self.isLoading = false
            self.delegate?.schedulesRepositoryDidFinsishLoading(self, error: error)
        }
    }
}
