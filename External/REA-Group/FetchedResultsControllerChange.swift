//
// Copyright (c) 2014 REA Group. All rights reserved.
//

import Foundation

class FetchedResultsControllerChange
{
    let changedObject: AnyObject
    let indexPath: NSIndexPath
    let changeType: SNRFetchedResultsChangeType
    let movedToIndexPath: NSIndexPath
    
    init (changedObject: AnyObject, atIndexPath indexPath: NSIndexPath, forChangeType changeType: SNRFetchedResultsChangeType, newIndexPath movedToIndexPath: NSIndexPath)
    {
        self.changedObject = changedObject
        self.indexPath = indexPath
        self.changeType = changeType
        self.movedToIndexPath = movedToIndexPath
    }
}
