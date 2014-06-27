//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsStorageKit

class RouteSpec: QuickSpec {
    override func spec() {
        var store: CoreDataTestsHelperStore!
        var moc: NSManagedObjectContext!
        
        beforeEach {
            store = CoreDataTestsHelperStore()
            moc = store.managedObjectContext
        }
        
        afterEach {
            let success = moc.save(nil)
        }
        
        describe("A Route") {
            var route: Route!
            
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
        
        describe("Multiple Routes") {
            describe ("asRoutesWithManagedObjectContext") {
                
                var routes: NSManagedObjectID[]!
                var storedRoutes: Route[]!
                
                beforeEach {
                    let json1: NSDictionary = [
                        "RouteNo": 5,
                        "InternalRouteNo": 10,
                        "AlphaNumericRouteNo": "5a",
                        "Destination": "Melbourne",
                        "IsUpDestination": true,
                        "HasLowFloor": true
                    ]
                    
                    let json2: NSDictionary = [
                        "RouteNo": 10,
                        "InternalRouteNo": 25,
                        "AlphaNumericRouteNo": "6a",
                        "Destination": "Pyrmont",
                        "IsUpDestination": false,
                        "HasLowFloor": false
                    ]
                    
                    let array: NSDictionary[] = [json1, json2]
                    routes = Route.insertRoutesFromArray(array, inManagedObjectContext: moc)
                    moc.save(nil)
                    
                    let request = NSFetchRequest(entityName: "Route")
                    request.sortDescriptors = [NSSortDescriptor(key: "routeNo", ascending:true)]
                    storedRoutes = moc.executeFetchRequest(request, error: nil) as? Route[]
                }
                
                it("should have 2 routes") {
                    expect(routes.count).to.equal(2)
                }
                
                it("should not return temporary IDs") {
                    expect(routes[0].temporaryID).to.beFalse()
                }
                
                it("should have a route entity") {
                    expect(routes[1].entity.name).to.equal("Route")
                }
                
                it("should create and store 2 routes") {
                    expect(storedRoutes.count).to.equal(2)
                }
                
                it("should have set it's routeNo") {
                    let route = storedRoutes[0]
                    expect(route.routeNo).to.equal(5)
                }
                
                it("should have set it's destination") {
                    let route = storedRoutes[1]
                    expect(route.destination).to.equal("Pyrmont")
                }
            }
            
            describe("fetchAllRoutesForManagedObjectIds") {
                
                var result: (routes: Route[]?, error:NSError?)?
                
                context("when empty") {
                    beforeEach() {
                        result = Route.fetchAllRoutesForManagedObjectIds([NSManagedObjectID()], usingManagedObjectContext: moc)
                    }
                    
                    it("should return an empty array of routes") {
                        expect(result?.routes?.count).to.equal(0)
                    }
                    
                    it("should return no error") {
                        expect(result?.error).to.beNil()
                    }
                }
                
                context("when not empty") {
                    
                    var routes: Route[]?
                    
                    beforeEach() {
                        let route1 = Route.insertInManagedObjectContext(moc)
                        route1.routeNo = 6
                        
                        let route2 = Route.insertInManagedObjectContext(moc)
                        route2.routeNo = 10
                        
                        let route3 = Route.insertInManagedObjectContext(moc)
                        route3.routeNo = 11
                        
                        moc.obtainPermanentIDsForObjects([route1, route2, route3], error: nil)
                        moc.save(nil)
                        
                        result = Route.fetchAllRoutesForManagedObjectIds([route2.objectID], usingManagedObjectContext: moc)
                    }
                    
                    it("should return on route inside an array") {
                        expect(result?.routes?.count).to.equal(1)
                    }
                    
                    it("should have the property routeNo") {
                        expect(result?.routes?[0].routeNo).to.equal(10)
                    }
                    
                    it("should return no error") {
                        expect(result?.error).to.beNil()
                    }
                }
                
                pending("when an error occurs") {
                    // FIXME: Test returned an error
                    // would like to test here when an error occurs, but it would be quite hard
                    // without exposing the internal of the class
                }
            }
        }
    }
}
