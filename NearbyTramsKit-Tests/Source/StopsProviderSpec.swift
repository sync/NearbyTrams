//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsKit
import NearbyTramsNetworkKit
import NearbyTramsStorageKit

class StopsProviderSpec: QuickSpec {
    override func spec() {
        var store: CoreDataTestsHelperStore!
        var moc: NSManagedObjectContext!
        var networkService: NetworkService!
        var provider: StopsProvider!
        
        beforeEach {
            store = CoreDataTestsHelperStore()
            moc = store.managedObjectContext
            
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let urlProcolClass: AnyObject = ClassUtility.classFromType(MockWebServiceURLProtocol.self)
            configuration.protocolClasses = [urlProcolClass]
            networkService = NetworkService(baseURL: NSURL(string: "mock://www.apple.com"), configuration: configuration)
            
            provider = StopsProvider(networkService: networkService, managedObjectContext: moc)
        }
        
        afterEach {
            let success = moc.save(nil)
        }
        
        describe("getStopsWithRouteNo") {
            
            var completionStops: [NSManagedObjectID]!
            var completionError: NSError!
            
            context("when some stops are available") {
                beforeEach {
                    var json1: Dictionary<String, AnyObject> = [ : ]
                    json1["Description"] = "a description"
                    json1["Latitude"] = -36.45
                    json1["Longitude"] = 145.68
                    json1["StopName"] = "Burke Rd / Canterbury Rd"
                    json1["StopNo"] = 14
                    json1["SuburbName"] = "Canterbury"
                    json1["UpStop"] = false
                    
                    var json2: Dictionary<String, AnyObject> = [ : ]
                    json2["Description"] = "another description"
                    json2["Latitude"] = -46.45
                    json2["Longitude"] = 135.68
                    json2["StopName"] = "John Rd / Canterbury Rd"
                    json2["StopNo"] = 17
                    json2["SuburbName"] = "Camberwell"
                    json1["UpStop"] = true
                    
                    let responseGetStopBody = ["responseObject": [json1, json2]]
                    let responseGetStop = MockWebServiceResponse(body: responseGetStopBody, header: ["Content-Type": "application/json; charset=utf-8"], urlComponentToMatch:"GetRouteStopsByRoute")
                    
                    json1 = [ : ]
                    json1["CityDirection"] = "from city"
                    json1["StopName"] = 0
                    json1["Longitude"] = 0
                    json1["StopName"] = "Rathmines Rd / Canterbury Rd"
                    json1["Zones"] = "1"
                    
                    let responseGetStopInfoBody = ["responseObject": json1]
                    let responseGetStopInfo = MockWebServiceResponse(body: responseGetStopInfoBody, header: ["Content-Type": "application/json; charset=utf-8"], urlComponentToMatch:"GetStopInformation")
                    
                    MockWebServiceURLProtocol.cannedResponses([responseGetStop, responseGetStopInfo])
                }
                
                afterEach {
                    MockWebServiceURLProtocol.cannedResponse(nil)
                }
                
                it("should complete on the main thread with stops and no error") {
                    provider.getStopsWithRouteNo(56, requestStopInfo: true, managedObjectContext: moc, {
                        stops, error -> Void in
                        
                        completionStops = stops
                        completionError = error
                        })
                    
                    expect{completionStops}.toEventuallyNot(beEmpty())
                    expect{completionError}.toEventually(beNil())
                }
            }
            
            context("when no stops are available") {
                beforeEach {
                    let body = ["responseObject": []]
                    let response = MockWebServiceResponse(body: body, header: ["Content-Type": "application/json; charset=utf-8"])
                    MockWebServiceURLProtocol.cannedResponse(response)
                }
                
                afterEach {
                    MockWebServiceURLProtocol.cannedResponse(nil)
                }
                
                it("should complete on the main thread with no stops and no error") {
                    provider.getStopsWithRouteNo(56, managedObjectContext: moc, {
                        stops, error -> Void in
                        
                        completionStops = stops
                        completionError = error
                        })
                    
                    expect{completionStops}.toEventually(beEmpty())
                    expect{completionError}.toEventually(beNil())
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
                
                it("should complete on the main thread with an error an no stops") {
                    provider.getStopsWithRouteNo(56, managedObjectContext: moc, {
                        stops, error -> Void in
                        
                        completionStops = stops
                        completionError = error
                        })
                    
                    expect{completionStops}.toEventually(beNil())
                    expect{completionError}.toEventually(equal(error))
                }
            }
        }
        
        describe("getStopInformationWithStopNo") {
            
            var completionStop: NSManagedObjectID!
            var completionError: NSError!
            
            beforeEach {
                let stop = Stop.insertInManagedObjectContext(moc) as Stop
                stop.uniqueIdentifier = "56"
                stop.stopNo = 56
                moc.save(nil)
            }
            
            context("when some stops are available") {
                beforeEach {
                    var json1: Dictionary<String, AnyObject> = [ : ]
                    json1["CityDirection"] = "from city"
                    json1["Latitude"] = 0
                    json1["Longitude"] = 0
                    json1["StopName"] = "Rathmines Rd / Canterbury Rd"
                    json1["Zones"] = "1"                    
                    
                    let body = ["responseObject": [json1]]
                    let response = MockWebServiceResponse(body: body, header: ["Content-Type": "application/json; charset=utf-8"])
                    MockWebServiceURLProtocol.cannedResponse(response)
                }
                
                afterEach {
                    MockWebServiceURLProtocol.cannedResponse(nil)
                }
                
                it("should complete on the main thread with stops and no error") {
                    provider.getStopInformationWithStopNo(56, managedObjectContext: moc, {
                        stop, error -> Void in
                        
                        completionStop = stop
                        completionError = error
                        })
                    
                    expect{completionStop}.toEventuallyNot(beNil())
                    expect{completionError}.toEventually(beNil())
                }
            }
            
            context("when no stops are available") {
                beforeEach {
                    let body = ["responseObject": [[ : ]]]
                    let response = MockWebServiceResponse(body: body, header: ["Content-Type": "application/json; charset=utf-8"])
                    MockWebServiceURLProtocol.cannedResponse(response)
                }
                
                afterEach {
                    MockWebServiceURLProtocol.cannedResponse(nil)
                }
                
                it("should complete on the main thread with no stops and no error") {
                    provider.getStopInformationWithStopNo(56, managedObjectContext: moc, {
                        stop, error -> Void in
                        
                        completionStop = stop
                        completionError = error
                        })
                    
                    expect{completionStop}.toEventuallyNot(beNil())
                    expect{completionError}.toEventually(beNil())
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
                
                it("should complete on the main thread with an error an no stops") {
                    provider.getStopInformationWithStopNo(56, managedObjectContext: moc, {
                        stop, error -> Void in
                        
                        completionStop = stop
                        completionError = error
                        })
                    
                    expect{completionStop}.toEventually(beNil())
                    expect{completionError}.toEventually(equal(error))
                }
            }
        }
    }
}
