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
            
            context("when some stops are avaible") {
                beforeEach {
                    var json1: Dictionary<String, AnyObject> = [ : ]
                    json1["CityDirection"] = "a city direction"
                    json1["Description"] = "a description"
                    json1["Destination"] = "a destination"
                    json1["FlagStopNo"] = "Stop 965a"
                    json1["RouteNo"] = 5
                    json1["StopID"] = "567aab"
                    json1["StopName"] = "Burke Rd / Canterbury Rd"
                    json1["StopNo"] = 14
                    json1["Suburb"] = "Canterbury"
                    json1["DistanceToLocation"] = 14.00
                    json1["Latitude"] = -36.45
                    json1["Longitude"] = 145.68
                    
                    var json2: Dictionary<String, AnyObject> = [ : ]
                    json2["CityDirection"] = "a camberwell direction"
                    json2["Description"] = "another description"
                    json2["Destination"] = "another destination"
                    json2["FlagStopNo"] = "Stop 145a"
                    json2["RouteNo"] = NSNull()
                    json2["StopID"] = "547bab"
                    json2["StopName"] = "John Rd / Canterbury Rd"
                    json2["StopNo"] = 17
                    json2["Suburb"] = "Camberwell"
                    json2["DistanceToLocation"] = 11.00
                    json2["Latitude"] = -46.45
                    json2["Longitude"] = 135.68
                    
                    let responseGetStopBody = ["ResponseObject": [json1, json2]]
                    let responseGetStop = MockWebServiceResponse(body: responseGetStopBody, header: ["Content-Type": "application/json; charset=utf-8"], urlComponentToMatch:"GetStopsByRouteAndDirection.ashx")
                    
                    json1 = [ : ]
                    json1["CityDirection"] = "from city"
                    json1["Description"] = NSNull()
                    json1["Destination"] = NSNull()
                    json1["FlagStopNo"] = "66"
                    json1["RouteNo"] = 0
                    json1["StopID"] =  NSNull()
                    json1["StopName"] = "Rathmines Rd / Canterbury Rd"
                    json1["StopNo"] = 0
                    json1["Suburb"] = "Canterbury"
                    json1["DistanceToLocation"] = 0
                    json1["Latitude"] = 0
                    json1["Longitude"] = 0
                    
                    let responseGetStopInfoBody = ["ResponseObject": json1]
                    let responseGetStopInfo = MockWebServiceResponse(body: responseGetStopInfoBody, header: ["Content-Type": "application/json; charset=utf-8"], urlComponentToMatch:"GetStopInformation.ashx")
                    
                    MockWebServiceURLProtocol.cannedResponses([responseGetStop, responseGetStopInfo])
                }
                
                afterEach {
                    MockWebServiceURLProtocol.cannedResponse(nil)
                }
                
                it("should complete on the main thread with stops and no error") {
                    provider.getStopsWithRouteNo(56, isUpDestination: false, requestStopInfo: true, managedObjectContext: moc, {
                        stops, error -> Void in
                        
                        completionStops = stops
                        completionError = error
                        })
                    
                    expect{completionStops}.willNot.beEmpty()
                    expect{completionError}.will.beNil()
                }
            }
            
            context("when no stops are available") {
                beforeEach {
                    let body = ["ResponseObject": []]
                    let response = MockWebServiceResponse(body: body, header: ["Content-Type": "application/json; charset=utf-8"])
                    MockWebServiceURLProtocol.cannedResponse(response)
                }
                
                afterEach {
                    MockWebServiceURLProtocol.cannedResponse(nil)
                }
                
                it("should complete on the main thread with no stops and no error") {
                    provider.getStopsWithRouteNo(56, isUpDestination: true, managedObjectContext: moc, {
                        stops, error -> Void in
                        
                        completionStops = stops
                        completionError = error
                        })
                    
                    expect{completionStops}.will.beEmpty()
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
                
                it("should complete on the main thread with an error an no stops") {
                    provider.getStopsWithRouteNo(56, isUpDestination: true, managedObjectContext: moc, {
                        stops, error -> Void in
                        
                        completionStops = stops
                        completionError = error
                        })
                    
                    expect{completionStops}.will.beNil()
                    expect{completionError}.will.equal(error)
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
                    json1["Description"] = NSNull()
                    json1["Destination"] = NSNull()
                    json1["FlagStopNo"] = "66"
                    json1["RouteNo"] = 0
                    json1["StopID"] =  NSNull()
                    json1["StopName"] = "Rathmines Rd / Canterbury Rd"
                    json1["StopNo"] = 0
                    json1["Suburb"] = "Canterbury"
                    json1["DistanceToLocation"] = 0
                    json1["Latitude"] = 0
                    json1["Longitude"] = 0
                    
                    let body = ["ResponseObject": json1]
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
                    
                    expect{completionStop}.willNot.beNil()
                    expect{completionError}.will.beNil()
                }
            }
            
            context("when no stops are available") {
                beforeEach {
                    let body = ["ResponseObject": [ : ]]
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
                    
                    expect{completionStop}.willNot.beNil()
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
                
                it("should complete on the main thread with an error an no stops") {
                    provider.getStopInformationWithStopNo(56, managedObjectContext: moc, {
                        stop, error -> Void in
                        
                        completionStop = stop
                        completionError = error
                        })
                    
                    expect{completionStop}.will.beNil()
                    expect{completionError}.will.equal(error)
                }
            }
        }
    }
}
