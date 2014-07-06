//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsKit

class FetchedResultsControllerChangeSetSpec: QuickSpec {
    override func spec() {
        describe ("a change set") {
            var changeSet: FetchedResultsControllerChangeSet!
            
            beforeEach {
                changeSet = FetchedResultsControllerChangeSet()
            }
            
            context ("with an insert change") {
                var changedObject = NSObject()
                
                beforeEach {
                    let change = FetchedResultsControllerChange(changedObject: changedObject, atIndexPath:  NSIndexPath(index: 5), forChangeType: SNRFetchedResultsChangeInsert, newIndexPath:  NSIndexPath(index: 3))
                    changeSet.addChange(change)
                }
                
                it ("should have one inserted object") {
                    expect(changeSet.allAddedObjects.count).to.equal(1)
                }
                
                it ("should return the right inserted object") {
                    expect(changeSet.allAddedObjects).to.contain(changedObject)
                }
            }
            
            context ("with a couple of insert changes") {
                var changedObjectOne = NSObject()
                var changedObjectTwo = NSObject()
                
                beforeEach {
                    let changeOne = FetchedResultsControllerChange(changedObject: changedObjectOne, atIndexPath:  NSIndexPath(index: 5), forChangeType: SNRFetchedResultsChangeInsert, newIndexPath:  NSIndexPath(index: 3))
                    changeSet.addChange(changeOne)
                    
                    let changeTwo = FetchedResultsControllerChange(changedObject: changedObjectTwo, atIndexPath:  NSIndexPath(index: 5), forChangeType: SNRFetchedResultsChangeInsert, newIndexPath:  NSIndexPath(index: 3))
                    changeSet.addChange(changeTwo)
                }
                
                it ("should have two inserted objects") {
                    expect(changeSet.allAddedObjects).to.contain(changedObjectOne)
                    expect(changeSet.allAddedObjects).to.contain(changedObjectTwo)
                }
            }
            
            context ("with an update change") {
                var changedObject = NSObject()
                
                beforeEach {
                    let change = FetchedResultsControllerChange(changedObject: changedObject, atIndexPath:  NSIndexPath(index: 5), forChangeType: SNRFetchedResultsChangeUpdate, newIndexPath:  NSIndexPath(index: 3))
                    changeSet.addChange(change)
                }
                
                it ("should have one changed object") {
                    expect(changeSet.allUpdatedObjects.count).to.equal(1)
                }
                
                it ("should return the right changed object") {
                    expect(changeSet.allUpdatedObjects).to.contain(changedObject)
                }
            }
            
            context ("with a couple of update changes") {
                var changedObjectOne = NSObject()
                var changedObjectTwo = NSObject()
                
                beforeEach {
                    let changeOne = FetchedResultsControllerChange(changedObject: changedObjectOne, atIndexPath:  NSIndexPath(index: 5), forChangeType: SNRFetchedResultsChangeUpdate, newIndexPath:  NSIndexPath(index: 3))
                    changeSet.addChange(changeOne)
                    
                    let changeTwo = FetchedResultsControllerChange(changedObject: changedObjectTwo, atIndexPath:  NSIndexPath(index: 5), forChangeType: SNRFetchedResultsChangeUpdate, newIndexPath:  NSIndexPath(index: 3))
                    changeSet.addChange(changeTwo)
                }
                
                it ("should have two upated objects") {
                    expect(changeSet.allUpdatedObjects).to.contain(changedObjectOne)
                    expect(changeSet.allUpdatedObjects).to.contain(changedObjectTwo)
                }
            }
            
            context ("with an delete change") {
                var changedObject = NSObject()
                
                beforeEach {
                    let change = FetchedResultsControllerChange(changedObject: changedObject, atIndexPath:  NSIndexPath(index: 5), forChangeType: SNRFetchedResultsChangeDelete, newIndexPath:  NSIndexPath(index: 3))
                    changeSet.addChange(change)
                }
                
                it ("should have one deleted object") {
                    expect(changeSet.allRemovedObjects.count).to.equal(1)
                }
                
                it ("should return the right deletedd object") {
                    expect(changeSet.allRemovedObjects).to.contain(changedObject)
                }
            }
            
            context ("with a couple of delete changes") {
                var changedObjectOne = NSObject()
                var changedObjectTwo = NSObject()
                
                beforeEach {
                    let changeOne = FetchedResultsControllerChange(changedObject: changedObjectOne, atIndexPath:  NSIndexPath(index: 5), forChangeType: SNRFetchedResultsChangeDelete, newIndexPath:  NSIndexPath(index: 3))
                    changeSet.addChange(changeOne)
                    
                    let changeTwo = FetchedResultsControllerChange(changedObject: changedObjectTwo, atIndexPath:  NSIndexPath(index: 5), forChangeType: SNRFetchedResultsChangeDelete, newIndexPath:  NSIndexPath(index: 3))
                    changeSet.addChange(changeTwo)
                }
                
                it ("should have two deleted objects") {
                    expect(changeSet.allRemovedObjects).to.contain(changedObjectOne)
                    expect(changeSet.allRemovedObjects).to.contain(changedObjectTwo)
                }
            }
            
            context ("with a combination of changes") {
                var changedObjectOne = NSObject()
                var changedObjectTwo = NSObject()
                var changedObjectThree = NSObject()
                
                beforeEach {
                    let changeOne = FetchedResultsControllerChange(changedObject: changedObjectOne, atIndexPath:  NSIndexPath(index: 5), forChangeType: SNRFetchedResultsChangeInsert, newIndexPath:  NSIndexPath(index: 3))
                    changeSet.addChange(changeOne)
                    
                    let changeTwo = FetchedResultsControllerChange(changedObject: changedObjectTwo, atIndexPath:  NSIndexPath(index: 5), forChangeType: SNRFetchedResultsChangeUpdate, newIndexPath:  NSIndexPath(index: 3))
                    changeSet.addChange(changeTwo)
                    
                    let changeThree = FetchedResultsControllerChange(changedObject: changedObjectThree, atIndexPath:  NSIndexPath(index: 5), forChangeType: SNRFetchedResultsChangeDelete, newIndexPath:  NSIndexPath(index: 3))
                    changeSet.addChange(changeThree)
                }
                
                it ("should have one inserted object") {
                    expect(changeSet.allAddedObjects.count).to.equal(1)
                }
                
                it ("should return the right inserted object") {
                    expect(changeSet.allAddedObjects).to.contain(changedObjectOne)
                }
                it ("should have one changed object") {
                    expect(changeSet.allUpdatedObjects.count).to.equal(1)
                }
                
                it ("should return the right changed object") {
                    expect(changeSet.allUpdatedObjects).to.contain(changedObjectTwo)
                }
                it ("should have one deleted object") {
                    expect(changeSet.allRemovedObjects.count).to.equal(1)
                }
                
                it ("should return the right deletedd object") {
                    expect(changeSet.allRemovedObjects).to.contain(changedObjectThree)
                }
            }
        }
    }
}
