//
// Copyright (c) 2014 REA Group. All rights reserved.
//

import Foundation

public class FetchedResultsControllerChangeSet
{
    public var changes: [FetchedResultsControllerChange]
    
    public init()
    {
        changes = []
    }
    
    public var changesCount: Int {
    get {
        return changes.count
    }
    }
    
    public func addChange(change: FetchedResultsControllerChange)
    {
        changes.append(change)
    }
    
    public func changedObjectsForChangeType(changeType: SNRFetchedResultsChangeType) -> [AnyObject]
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
    
    public var allUpdatedObjects: [AnyObject] {
    get {
        return changedObjectsForChangeType(SNRFetchedResultsChangeUpdate)
    }
    }
    
    public var allAddedObjects: [AnyObject] {
    get {
        return changedObjectsForChangeType(SNRFetchedResultsChangeInsert)
    }
    }
    
    public var allRemovedObjects: [AnyObject] {
    get {
        return changedObjectsForChangeType(SNRFetchedResultsChangeDelete)
    }
    }
}
