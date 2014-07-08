//
// Copyright (c) 2014 REA Group. All rights reserved.
//

import Foundation

class FetchedResultsControllerChangeSet
{
    var changes: [FetchedResultsControllerChange]
    
    init()
    {
        changes = []
    }
    
    var changesCount: Int {
    get {
        return changes.count
    }
    }
    
    func addChange(change: FetchedResultsControllerChange)
    {
        changes.append(change)
    }
    
    func changedObjectsForChangeType(changeType: SNRFetchedResultsChangeType) -> [AnyObject]
    {
        let matchedChanges = changes.filter{
            change -> Bool in
            
            return change.changeType == changeType
        }.map {
            change -> AnyObject in
            
            return change.changedObject
        }
        
        return matchedChanges
    }
    
    var allUpdatedObjects: [AnyObject] {
    get {
        return changedObjectsForChangeType(SNRFetchedResultsChangeUpdate)
    }
    }
    
    var allAddedObjects: [AnyObject] {
    get {
        return changedObjectsForChangeType(SNRFetchedResultsChangeInsert)
    }
    }
    
    var allRemovedObjects: [AnyObject] {
    get {
        return changedObjectsForChangeType(SNRFetchedResultsChangeDelete)
    }
    }
}
