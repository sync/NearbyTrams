//
// Copyright (c) 2014 REA Group. All rights reserved.
//

import Foundation

public class FetchedResultsControllerChange
{
    public let changedObject: AnyObject
    public let indexPath: NSIndexPath
    public let changeType: SNRFetchedResultsChangeType
    public let movedToIndexPath: NSIndexPath
    
    public init (changedObject: AnyObject, atIndexPath indexPath: NSIndexPath, forChangeType changeType: SNRFetchedResultsChangeType, newIndexPath movedToIndexPath: NSIndexPath)
    {
        self.changedObject = changedObject
        self.indexPath = indexPath
        self.changeType = changeType
        self.movedToIndexPath = movedToIndexPath
    }
}
