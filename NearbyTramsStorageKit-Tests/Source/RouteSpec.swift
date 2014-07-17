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
                    route = Route.insertInManagedObjectContext(moc) as Route
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
                    route = Route.insertInManagedObjectContext(moc) as Route
                }
                
                context("with valid values") {
                    beforeEach {
                        let json: Dictionary<String, AnyObject> = [
                            "RouteNumber": 5,
                            "Name": "Melbourne",
                            "IsUpStop": true
                        ]
                        
                        route.configureWithDictionaryFromRest(json)
                    }
                    
                    it("should have a routeNo") {
                        expect(route.routeNo).to.equal(5)
                    }
                    
                    it("should have a name") {
                        expect(route.name).to.equal("Melbourne")
                    }
                    
                    it("should be an up stop route") {
                        expect(route.isUpStop).to.beTrue()
                    }
                }
                
                context("with invalid values") {
                    beforeEach {
                        let json: Dictionary<String, AnyObject> = [
                            "RouteNumber": "5",
                            "Name": NSNull(),
                            "IsUpStop": "test"
                        ]
                        
                        route.configureWithDictionaryFromRest(json)
                    }
                    
                    it("should not have a routeNo") {
                        expect(route.routeNo).to.beNil()
                    }
                    
                    it("should not have a name") {
                        expect(route.name).to.beNil()
                    }
                    
                    it("should not be an up stop route") {
                        expect(route.isUpStop).to.beFalse()
                    }
                }
            }
        }
        
        describe("Rest") {
            describe ("insertOrUpdateRouteWithDictionaryFromRest") {
                
                var result: (route: Route?, error: NSError?)!
                var storedRoutes: Route[]!
                
                beforeEach {
                    let json: NSDictionary = [
                        "RouteNumber": 5,
                        "Name": "Melbourne",
                        "IsUpStop": true
                    ]
                    
                    result = Route.insertOrUpdateWithDictionaryFromRest(json, inManagedObjectContext: moc) as (route: Route?, error: NSError?)
                    moc.save(nil)
                    
                    let request = NSFetchRequest(entityName: "Route")
                    request.sortDescriptors = [NSSortDescriptor(key: "routeNo", ascending:true)]
                    storedRoutes = moc.executeFetchRequest(request, error: nil) as? Route[]
                }
                
                it("should have a route") {
                    expect(result.route).notTo.beNil()
                }
                
                it("should have a no error") {
                    expect(result.error).to.beNil()
                }
                
                it("should have a routeNo") {
                    expect(result.route?.routeNo).to.equal(5)
                }
                
                it("should create and store one route") {
                    expect(storedRoutes.count).to.equal(1)
                }
                
                it("should have set it's routeNo") {
                    let storedRoute = storedRoutes[0]
                    expect(storedRoute.routeNo).to.equal(5)
                }
                
                it("should have set it's name") {
                    let storedRoute = storedRoutes[0]
                    expect(storedRoute.name).to.equal("Melbourne")
                }
            }
            
            describe ("insertOrUpdateRoutesFromRestArray") {
                
                var results: (routes: Route?[], errors: NSError?[])!
                var routes: Route?[]!
                var errors: NSError?[]!
                var storedRoutes: Route[]!
                
                beforeEach {
                    let json1: NSDictionary = [
                        "RouteNumber": 5,
                        "Name": "Melbourne",
                        "IsUpStop": true
                    ]
                    
                    let json2: NSDictionary = [
                        "RouteNumber": 10,
                        "Name": "Pyrmont",
                        "IsUpStop": false
                    ]
                    
                    let json3: NSDictionary = [
                        "RouteNumber": 10,
                        "Name": "Pyrmont",
                        "IsUpStop": false
                    ]
                    
                    let array: NSDictionary[] = [json1, json2, json3]
                    results = Route.insertOrUpdateFromRestArray(array, inManagedObjectContext: moc) as (routes: Route?[], errors: NSError?[])
                    moc.save(nil)
                    
                    routes = results.routes
                    errors = results.errors
                    
                    let request = NSFetchRequest(entityName: "Route")
                    request.sortDescriptors = [NSSortDescriptor(key: "routeNo", ascending:true)]
                    storedRoutes = moc.executeFetchRequest(request, error: nil) as? Route[]
                }
                
                it("should have 2 routes") {
                    expect(routes.count).to.equal(3)
                }
                
                it("should have 2 errors") {
                    expect(errors.count).to.equal(3)
                }
                
                it("should have a routeNo") {
                    expect(routes[0]?.routeNo).to.equal(5)
                }
                
                it("should have a route name") {
                    expect(routes[2]?.name).to.equal("Pyrmont")
                }
                
                it("should create and store 2 routes") {
                    expect(storedRoutes.count).to.equal(2)
                }
                
                it("should have set it's routeNo") {
                    let storedRoute = storedRoutes[0]
                    expect(storedRoute.routeNo).to.equal(5)
                }
                
                it("should have set it's name") {
                    let storedRoute = storedRoutes[1]
                    expect(storedRoute.name).to.equal("Pyrmont")
                }
            }
        }
        
        describe("Fetching route(s)") {
            describe("fetchOneRouteForPrimaryKey") {
                
                var result: (route: Route?, error:NSError?)!
                
                context("when empty") {
                    beforeEach() {
                        result = Route.fetchOneForPrimaryKeyValue(5, usingManagedObjectContext: moc)
                    }
                    
                    it("should return no route") {
                        expect(result.route?).to.beNil()
                    }
                    
                    it("should return no error") {
                        expect(result.error).to.beNil()
                    }
                }
                
                context("when not empty") {
                    
                    beforeEach() {
                        let route1: Route = Route.insertInManagedObjectContext(moc)
                        route1.uniqueIdentifier = "composed-6"
                        
                        let route2: Route = Route.insertInManagedObjectContext(moc)
                        route2.uniqueIdentifier = "composed-10"
                        
                        let route3: Route = Route.insertInManagedObjectContext(moc)
                        route3.uniqueIdentifier = "composed-11"
                        
                        moc.save(nil)
                        
                        result = Route.fetchOneForPrimaryKeyValue("composed-10", usingManagedObjectContext: moc)
                    }
                    
                    it("should return one route") {
                        expect(result?.route?.uniqueIdentifier).to.equal("composed-10")
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
            
            describe("fetchAllRoutesForManagedObjectIds") {
                
                var result: (routes: Route[]?, error:NSError?)!
                
                context("when empty") {
                    beforeEach() {
                        result = Route.fetchAllForManagedObjectIds([NSManagedObjectID()], usingManagedObjectContext: moc)
                    }
                    
                    it("should return an empty array of routes") {
                        expect(result.routes?.count).to.equal(0)
                    }
                    
                    it("should return no error") {
                        expect(result.error).to.beNil()
                    }
                }
                
                context("when not empty") {
                    beforeEach() {
                        let route1: Route = Route.insertInManagedObjectContext(moc)
                        route1.routeNo = 6
                        
                        let route2: Route = Route.insertInManagedObjectContext(moc)
                        route2.routeNo = 10
                        
                        let route3: Route = Route.insertInManagedObjectContext(moc)
                        route3.routeNo = 11
                        
                        moc.obtainPermanentIDsForObjects([route1, route2, route3], error: nil)
                        moc.save(nil)
                        
                        result = Route.fetchAllForManagedObjectIds([route2.objectID], usingManagedObjectContext: moc)
                    }
                    
                    it("should return one route") {
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
