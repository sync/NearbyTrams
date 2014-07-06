//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsKit

class FetchedResultsControllerChangeSpec: QuickSpec {
    override func spec() {
        describe("init") {
            var changedObject: NSObject!
            var indexPath: NSIndexPath!
            var changeType: SNRFetchedResultsChangeType!
            var movedToIndexPath: NSIndexPath!
            
            var change: FetchedResultsControllerChange!
            
            beforeEach {
                changedObject = NSObject()
                indexPath = NSIndexPath(index: 5)
                changeType = SNRFetchedResultsChangeInsert
                movedToIndexPath = NSIndexPath(index: 3)
                
                change = FetchedResultsControllerChange(changedObject: changedObject, atIndexPath: indexPath, forChangeType: changeType, newIndexPath: movedToIndexPath)
            }
            
            it ("should have a changed object") {
                var expectedChangedObject = change.changedObject as NSObject
                expect(expectedChangedObject).to.equal(changedObject)
            }
            
            it ("should have an index path") {
                expect(change.indexPath).to.equal(indexPath)
            }
            
            it ("should have achange type") {
                expect(change.changeType).to.equal(changeType)
            }
            
            it ("should have a moved index path") {
                expect(change.movedToIndexPath).to.equal(movedToIndexPath)
            }
        }
    }
}
