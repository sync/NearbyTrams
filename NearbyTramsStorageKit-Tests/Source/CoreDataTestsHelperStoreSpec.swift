//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsStorageKit

class CoreDataTestsStoreSpec: QuickSpec {
    override func spec() {
        describe("Managed Object Context") {
            var store: CoreDataTestsHelperStore!
            
            beforeEach {
                store = CoreDataTestsHelperStore()
            }
            
            it("should be non nil") {
                let moc = store.managedObjectContext
                expect(moc).notTo.beNil()
            }
        }
    }
}
