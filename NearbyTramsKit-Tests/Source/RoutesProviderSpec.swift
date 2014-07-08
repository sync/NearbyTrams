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
            
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let urlProcolClass: AnyObject = ClassUtility.classFromType(MockWebServiceURLProtocol.self)
            configuration.protocolClasses = [urlProcolClass]
            networkService = NetworkService(baseURL: NSURL(string: "mock://www.apple.com"), configuration: configuration)
            
            provider = RoutesProvider(networkService: networkService, managedObjectContext: moc)
        }
        
        afterEach {
            let success = moc.save(nil)
        }
        
        describe("getAllRoutesWithManagedObjectContext") {
            
            var completionRoutes: [NSManagedObjectID]!
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
                    MockWebServiceURLProtocol.cannedResponse(response)
                }
                
                afterEach {
                    MockWebServiceURLProtocol.cannedResponse(nil)
                }
                
                it("should complete on the main thread with routes and no error") {
                    provider.getAllRoutesWithManagedObjectContext(moc, {
                        routes, error -> Void in
                        
                        completionRoutes = routes
                        completionError = error
                        })
                    
                    expect{completionRoutes}.willNot.beEmpty()
                    expect{completionError}.will.beNil()
                }
            }
            
            context("when no routes are available") {
                beforeEach {
                   let body = ["ResponseObject": []]
                    let response = MockWebServiceResponse(body: body, header: ["Content-Type": "application/json; charset=utf-8"])
                    MockWebServiceURLProtocol.cannedResponse(response)
                }
                
                afterEach {
                    MockWebServiceURLProtocol.cannedResponse(nil)
                }
                
                it("should complete on the main thread with no routes and no error") {
                    provider.getAllRoutesWithManagedObjectContext(moc, {
                        routes, error -> Void in
                        
                        completionRoutes = routes
                        completionError = error
                        })
                    
                    expect{completionRoutes}.will.beEmpty()
                    expect{completionError}.will.beNil()
                }
            }
            
            context("when an error occur") {
                
                var error: NSError!
                
                beforeEach {
                    error = NSError(domain: "au.com.otherTest.provider", code: 150, userInfo: nil)
                    let response = MockWebServiceResponse(body: ["test": "blah"], header: ["Content-Type": "application/json; charset=utf-8"], statusCode: 404, error: error)
                    MockWebServiceURLProtocol.cannedResponse(response)
                }
                
                afterEach {
                    MockWebServiceURLProtocol.cannedResponse(nil)
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
