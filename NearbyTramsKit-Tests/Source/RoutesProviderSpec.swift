//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsKit
import NearbyTramsNetworkKit
import NearbyTramsStorageKit

class RoutesProviderSpec: QuickSpec {
    override func spec() {
        var store: CoreDataTestsHelperStore!
        var moc: NSManagedObjectContext!
        var networkService: NetworkService!
        var provider: RoutesProvider!
        
        beforeEach {
            store = CoreDataTestsHelperStore()
            moc = store.managedObjectContext
            
            let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
            let urlProcolClass: AnyObject = ClassUtility.classFromType(MockWebServiceURLProtocol.self)
            configuration.protocolClasses = [urlProcolClass]
            networkService = NetworkService(baseURL: NSURL(string: "mock://www.apple.com"), configuration: configuration)
            
            provider = RoutesProvider(networkService: networkService, managedObjectContext: moc)
        }
        
        afterEach {
            let success = moc.save(nil)
        }
        
        describe("fetchAllRoutesForManagedObjectIds") {
            
            var result: (routes: Route[]?, error:NSError?)?
            
            context("when empty") {
                beforeEach() {
                    result = provider.fetchAllRoutesForManagedObjectIds([NSManagedObjectID()], usingManagedObjectContext: moc)
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
                    
                    result = provider.fetchAllRoutesForManagedObjectIds([route2.objectID], usingManagedObjectContext: moc)
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

        
        describe("getAllRoutesWithManagedObjectContext") {
            
            var completionRoutes: Route[]!
            var completionError: NSError!
            
            context("when some routes are avaible") {
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
                    
                    let body = ["ResponseObject": [json1, json2]]
                    let response = MockWebServiceResponse(body: body, header: ["Content-Type": "application/json; charset=utf-8"])
                    MockWebServiceURLProtocol.cannedResponse = response
                }
                
                afterEach {
                    MockWebServiceURLProtocol.cannedResponse = nil
                }
                
                it("should complete on the main thread with routes and no error") {
                    provider.getAllRoutesWithManagedObjectContext(moc, {
                        routes, error -> Void in
                        
                        completionRoutes = routes
                        completionError = error
                        })
                    
                    expect{completionRoutes}.willNot.beNil()
                    expect{completionError}.will.beNil()
                }
            }
            
            context("when no routes are available") {
                beforeEach {
                   let body = ["ResponseObject": []]
                    let response = MockWebServiceResponse(body: body, header: ["Content-Type": "application/json; charset=utf-8"])
                    MockWebServiceURLProtocol.cannedResponse = response
                }
                
                afterEach {
                    MockWebServiceURLProtocol.cannedResponse = nil
                }
                
                it("should complete on the main thread with no routes and no error") {
                    provider.getAllRoutesWithManagedObjectContext(moc, {
                        routes, error -> Void in
                        
                        completionRoutes = routes
                        completionError = error
                        })
                    
                    expect{completionRoutes}.willNot.beNil()
                    expect{completionError}.will.beNil()
                }
            }
            
            context("when an error occur") {
                
                var error: NSError!
                
                beforeEach {
                    error = NSError(domain: "au.com.otherTest.provider", code: 150, userInfo: nil)
                    let response = MockWebServiceResponse(body: ["test": "blah"], header: ["Content-Type": "application/json; charset=utf-8"], statusCode: 404, error: error)
                    MockWebServiceURLProtocol.cannedResponse = response
                }
                
                afterEach {
                    MockWebServiceURLProtocol.cannedResponse = nil
                }
                
                it("should complete on the main thread with an error an no routes") {
                    provider.getAllRoutesWithManagedObjectContext(moc, {
                        routes, error -> Void in
                        
                        completionRoutes = routes
                        completionError = error
                        })
                    
                    expect{completionRoutes}.will.beNil()
                    expect{completionError}.will.equal(error)
                }
            }
        }
    }
}
