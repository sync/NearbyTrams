//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsStorageKit

class RouteSpec: QuickSpec {
    override func spec() {
        describe("A Route") {
            var store: CoreDataTestsHelperStore!
            var moc: NSManagedObjectContext!
            var route: Route!
            
            beforeEach {
                store = CoreDataTestsHelperStore()
                moc = store.managedObjectContext
            }
            
            afterEach {
                let success = moc.save(nil)
            }
            
            describe("insertInManagedObjectContext") {
                beforeEach {
                    route = Route.insertInManagedObjectContext(moc)
                }
                
                it("should be non nil") {
                    expect(route).notTo.beNil()
                }
                
                it("should be a member of the Route class") {
                    expect(route.isMemberOfClass(Route)).to.beTrue()
                }
            }
            
            describe("configureWithDictionaryFromRest") {
                beforeEach {
                    route = Route.insertInManagedObjectContext(moc)
                }
                
                context("with valid values") {
                    beforeEach {
                        let json: Dictionary<String, AnyObject> = [
                            "RouteNo": 5,
                            "InternalRouteNo": 10,
                            "AlphaNumericRouteNo": "5a",
                            "Destination": "Melbourne",
                            "IsUpDestination": true,
                            "HasLowFloor": true
                        ]
                        
                        route.configureWithDictionaryFromRest(json)
                    }
                    
                    it("should have a routeNo") {
                        expect(route.routeNo).to.equal(5)
                    }
                    
                    it("should have a InternalRouteNo") {
                        expect(route.internalRouteNo).to.equal(10)
                    }
                    
                    it("should have a AlphaNumericRouteNo") {
                        expect(route.alphaNumericRouteNo).to.equal("5a")
                    }
                    
                    it("should have a Destination") {
                        expect(route.destination).to.equal("Melbourne")
                    }
                    
                    it("should be an IsUpDestination route") {
                        expect(route.isUpDestination).to.beTrue()
                    }
                    
                    it("should be an HasLowFloor route") {
                        expect(route.hasLowFloor).to.beTrue()
                    }
                }
                
                context("with invalid values") {
                    beforeEach {
                        let json: Dictionary<String, AnyObject> = [
                            "RouteNo": "5",
                            "InternalRouteNo": NSNull(),
                            "AlphaNumericRouteNo": NSNull(),
                            "Destination": NSNull(),
                            "IsUpDestination": "test",
                            "HasLowFloor": "fake"
                        ]
                        
                        route.configureWithDictionaryFromRest(json)
                    }
                    
                    it("should have a RouteNo") {
                        expect(route.routeNo).to.beNil()
                    }
                    
                    it("should have a InternalRouteNo") {
                        expect(route.internalRouteNo).to.beNil()
                    }
                    
                    it("should have a AlphaNumericRouteNo") {
                        expect(route.alphaNumericRouteNo).to.beNil()
                    }
                    
                    it("should have a Destination") {
                        expect(route.destination).to.beNil()
                    }
                    
                    it("should be an IsUpDestination route") {
                        expect(route.isUpDestination).to.beFalse()
                    }
                    
                    it("should be an HasLowFloor route") {
                        expect(route.hasLowFloor).to.beFalse()
                    }
                }
            }
        }
    }
}
