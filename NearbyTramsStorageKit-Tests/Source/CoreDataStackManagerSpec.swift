//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsStorageKit

class CoreDataStackManagerSpec: QuickSpec {
    override func spec() {
        var manager: CoreDataStackManager!
        
        beforeEach {
            manager = CoreDataStackManager()
        }
        
        describe("Persistent Store Coordinator") {
            var psc: NSPersistentStoreCoordinator!
            
            beforeEach {
               psc = manager.persistentStoreCoordinator
            }
            
            it("should be non nil") {
                expect(psc).notTo(beNil())
            }
        }
        
        describe("Managed Object Context") {
            var moc: NSManagedObjectContext!
            
            beforeEach {
                moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
                moc.persistentStoreCoordinator = manager.persistentStoreCoordinator
            }
            
            it("should be non nil") {
                expect(moc).notTo(beNil())
            }
            
            it("should have a persistent coordinator") {
                expect(moc.persistentStoreCoordinator).notTo(beNil())
            }
        }
    }
}
