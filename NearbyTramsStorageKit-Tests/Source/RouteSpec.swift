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
                        var json: Dictionary<String, AnyObject> = [ : ]
                        json["AlphaNumericRouteNo"] = NSNull()
                        json["Description"] = "Melbourne Uni - Kew (Via St Kilda Beach)"
                        json["DownDestination"] = "Melbourne University"
                        json["HeadBoardRouteNo"] = 16
                        json["InternalRouteNo"] = 16
                        json["IsMainRoute"] = true
                        json["LastModified"] = "/Date(1365516000000+1000)/"
                        json["MainRouteNo"] = "16"
                        json["RouteColour"] = "yellow"
                        json["RouteNo"] = "16"
                        json["UpDestination"] = "Kew"
                        json["VariantDestination"] = NSNull()
                        
                        route.configureWithDictionaryFromRest(json)
                    }
                    
                    it("should have a routeNo") {
                        expect(route.routeNo).to.equal("16")
                    }
                    
                    it("should have an internal routeNo") {
                        expect(route.internalRouteNo).to.equal(16)
                    }
                    
                    it("should have a description") {
                        expect(route.routeDescription).to.equal("Melbourne Uni - Kew (Via St Kilda Beach)")
                    }
                    
                    it("should have a down destination") {
                        expect(route.downDestination).to.equal("Melbourne University")
                    }
                    
                    it("should have a up destination") {
                        expect(route.upDestination).to.equal("Kew")
                    }
                    
                    it("should have a color") {
                        expect(route.color).to.equal("yellow")
                    }
                }
                
                context("with invalid values") {
                    beforeEach {
                        var json: Dictionary<String, AnyObject> = [ : ]
                        json["AlphaNumericRouteNo"] = NSNull()
                        json["Description"] = NSNull()
                        json["DownDestination"] = NSNull()
                        json["HeadBoardRouteNo"] = NSNull()
                        json["InternalRouteNo"] = "test"
                        json["IsMainRoute"] = NSNull()
                        json["LastModified"] = NSNull()
                        json["MainRouteNo"] = NSNull()
                        json["RouteColour"] = NSNull()
                        json["RouteNo"] = NSNull()
                        json["UpDestination"] = true
                        json["VariantDestination"] = NSNull()
                        
                        route.configureWithDictionaryFromRest(json)
                    }
                    
                    it("should not have a routeNo") {
                        expect(route.routeNo).to.beNil()
                    }
                    
                    it("should not have an internal routeNo") {
                        expect(route.internalRouteNo).to.beNil()
                    }
                    
                    it("should not have a description") {
                        expect(route.routeDescription).to.beNil()
                    }
                    
                    it("should not have a down destination") {
                        expect(route.downDestination).to.beNil()
                    }
                    
                    it("should not have a up destination") {
                        expect(route.upDestination).to.beNil()
                    }
                    
                    it("should not have a color") {
                        expect(route.color).to.beNil()
                    }
                }
            }
        }
        
        describe("Rest") {
            describe ("insertOrUpdateRouteWithDictionaryFromRest") {
                var result: (route: Route?, error: NSError?)!
                var storedRoutes: Route[]!
                
                beforeEach {
                    var json: Dictionary<String, AnyObject> = [ : ]
                    json["AlphaNumericRouteNo"] = NSNull()
                    json["Description"] = "Melbourne Uni - Kew (Via St Kilda Beach)"
                    json["DownDestination"] = "Melbourne University"
                    json["HeadBoardRouteNo"] = 16
                    json["InternalRouteNo"] = 16
                    json["IsMainRoute"] = true
                    json["LastModified"] = "/Date(1365516000000+1000)/"
                    json["MainRouteNo"] = "16"
                    json["RouteColour"] = "yellow"
                    json["RouteNo"] = "16"
                    json["UpDestination"] = "Kew"
                    json["VariantDestination"] = NSNull()
                    
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
                    expect(result.route?.routeNo).to.equal("16")
                }
                
                it("should create and store one route") {
                    expect(storedRoutes.count).to.equal(1)
                }
                
                it("should have set it's routeNo") {
                    let storedRoute = storedRoutes[0]
                    expect(storedRoute.routeNo).to.equal("16")
                }
                
                it("should have set it's name") {
                    let storedRoute = storedRoutes[0]
                    expect(storedRoute.routeDescription).to.equal("Melbourne Uni - Kew (Via St Kilda Beach)")
                }
            }
            
            describe ("insertOrUpdateRoutesFromRestArray") {
                var results: (routes: Route?[], errors: NSError?[])!
                var routes: Route?[]!
                var errors: NSError?[]!
                var storedRoutes: Route[]!
                
                beforeEach {
                    var json1: Dictionary<String, AnyObject> = [ : ]
                    json1["AlphaNumericRouteNo"] = NSNull()
                    json1["Description"] = "Melbourne Uni - Kew (Via St Kilda Beach)"
                    json1["DownDestination"] = "Melbourne University"
                    json1["HeadBoardRouteNo"] = 16
                    json1["InternalRouteNo"] = 16
                    json1["IsMainRoute"] = true
                    json1["LastModified"] = "/Date(1365516000000+1000)/"
                    json1["MainRouteNo"] = "16"
                    json1["RouteColour"] = "yellow"
                    json1["RouteNo"] = "16"
                    json1["UpDestination"] = "Kew"
                    json1["VariantDestination"] = NSNull()
                    
                    var json2: Dictionary<String, AnyObject> = [ : ]
                    json2["AlphaNumericRouteNo"] = "3a"
                    json2["Description"] = "Melbourne Uni - East Malvern via St Kilda"
                    json2["DownDestination"] = "Melbourne University via St Kilda"
                    json2["HeadBoardRouteNo"] = 4
                    json2["InternalRouteNo"] = 4
                    json2["IsMainRoute"] = true
                    json2["LastModified"] = "/Date(1247532405497+1000)/"
                    json2["MainRouteNo"] = "4"
                    json2["RouteColour"] = "cyan"
                    json2["RouteNo"] = "3a"
                    json2["UpDestination"] = "East Malvern via St Kilda"
                    json2["VariantDestination"] = "via St Kilda"
                    
                    var json3: Dictionary<String, AnyObject> = [ : ]
                    json3["AlphaNumericRouteNo"] = "3a"
                    json3["Description"] = "Melbourne Uni - East Malvern via St Kilda"
                    json3["DownDestination"] = "Melbourne University via St Kilda"
                    json3["HeadBoardRouteNo"] = 4
                    json3["InternalRouteNo"] = 4
                    json3["IsMainRoute"] = true
                    json3["LastModified"] = "/Date(1247532405497+1000)/"
                    json3["MainRouteNo"] = "4"
                    json3["RouteColour"] = "cyan"
                    json3["RouteNo"] = "3a"
                    json3["UpDestination"] = "East Malvern via St Kilda"
                    json3["VariantDestination"] = "via St Kilda"
                    
                    let array: NSDictionary[] = [json1, json2, json3]
                    results = Route.insertOrUpdateFromRestArray(array, inManagedObjectContext: moc) as (routes: Route?[], errors: NSError?[])
                    moc.save(nil)
                    
                    routes = results.routes
                    errors = results.errors
                    
                    let request = NSFetchRequest(entityName: "Route")
                    // for string 10 is before than 5 --> ascending order
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
                    expect(routes[0]?.routeNo).to.equal("16")
                }
                
                it("should have a route description") {
                    expect(routes[2]?.routeDescription).to.equal("Melbourne Uni - East Malvern via St Kilda")
                }
                
                it("should create and store 2 routes") {
                    expect(storedRoutes.count).to.equal(2)
                }
                
                it("should have set it's routeNo") {
                    let storedRoute = storedRoutes[0]
                    expect(storedRoute.routeNo).to.equal("16")
                }
                
                it("should have set it's name") {
                    let storedRoute = storedRoutes[1]
                    expect(storedRoute.routeDescription).to.equal("Melbourne Uni - East Malvern via St Kilda")
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
                        route1.routeNo = "6"
                        
                        let route2: Route = Route.insertInManagedObjectContext(moc)
                        route2.routeNo = "10"
                        
                        let route3: Route = Route.insertInManagedObjectContext(moc)
                        route3.routeNo = "11"
                        
                        moc.obtainPermanentIDsForObjects([route1, route2, route3], error: nil)
                        moc.save(nil)
                        
                        result = Route.fetchAllForManagedObjectIds([route2.objectID], usingManagedObjectContext: moc)
                    }
                    
                    it("should return one route") {
                        expect(result?.routes?.count).to.equal(1)
                    }
                    
                    it("should have the property routeNo") {
                        expect(result?.routes?[0].routeNo).to.equal("10")
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
