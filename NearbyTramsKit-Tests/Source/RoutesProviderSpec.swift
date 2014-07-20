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
            
            var completionRoutes: NSManagedObjectID[]!
            var completionError: NSError!
            
            context("when some routes are available") {
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
                    
                    let body = ["responseObject": [json1, json2]]
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
                   let body = ["responseObject": []]
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
