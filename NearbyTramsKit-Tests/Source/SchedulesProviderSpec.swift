//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsKit
import NearbyTramsNetworkKit
import NearbyTramsStorageKit

class SchedulesProviderSpec: QuickSpec {
    override func spec() {
        var store: CoreDataTestsHelperStore!
        var moc: NSManagedObjectContext!
        var networkService: NetworkService!
        var provider: SchedulesProvider!
        
        beforeEach {
            store = CoreDataTestsHelperStore()
            moc = store.managedObjectContext
            
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let urlProcolClass: AnyObject = ClassUtility.classFromType(MockWebServiceURLProtocol.self)
            configuration.protocolClasses = [urlProcolClass]
            networkService = NetworkService(baseURL: NSURL(string: "mock://www.apple.com"), configuration: configuration)
            
            provider = SchedulesProvider(networkService: networkService, managedObjectContext: moc)
        }
        
        afterEach {
            let success = moc.save(nil)
        }
        
        describe("getNextPredictionsWithStopNo") {
            
            var completionSchedules: [NSManagedObjectID]!
            var completionError: NSError!
            
            context("when some schedules are available") {
                beforeEach {
                    let json1: Dictionary<String, AnyObject> = [
                        "AirConditioned": true,
                        "Destination": "Sth Melb Beach",
                        "DisplayAC": true,
                        "DisruptionMessage": [
                            "DisplayType": "Text",
                            "MessageCount": 2,
                            "Messages": ["Message 1", "Message 2"]
                        ],
                        "HasDisruption": true,
                        "HasSpecialEvent": true,
                        "HeadBoardRouteNo": "1",
                        "InternalRouteNo": 1,
                        "IsLowFloorTram": true,
                        "IsTTAvailable": true,
                        "PredictedArrivalDateTime": "/Date(1388977800000+1000)/",
                        "RouteNo": "1",
                        "SpecialEventMessage": "a special message",
                        "TripID": 10,
                        "VehicleNo": 2101
                    ]
                    
                    let body = ["responseObject": [json1]]
                    let response = MockWebServiceResponse(body: body, header: ["Content-Type": "application/json; charset=utf-8"])
                    MockWebServiceURLProtocol.cannedResponse(response)
                }
                
                afterEach {
                    MockWebServiceURLProtocol.cannedResponse(nil)
                }
                
                context("with no routeNo") {
                    it("should complete on the main thread with schedules and no error") {
                        provider.getNextPredictionsWithStopNo(56, managedObjectContext: moc, {
                            schedules, error -> Void in
                            
                            completionSchedules = schedules
                            completionError = error
                            })
                        
                        expect{completionSchedules}.willNot.beEmpty()
                        expect{completionError}.will.beNil()
                    }
                }
                
                context("with a routeNo") {
                    it("should complete on the main thread with schedules and no error") {
                        provider.getNextPredictionsWithStopNo(56, routeNo: "1", managedObjectContext: moc, {
                            schedules, error -> Void in
                            
                            completionSchedules = schedules
                            completionError = error
                            })
                        
                        expect{completionSchedules}.willNot.beEmpty()
                        expect{completionError}.will.beNil()
                    }
                }
            }
            
            context("when no schedules are available") {
                beforeEach {
                    let body = ["responseObject": []]
                    let response = MockWebServiceResponse(body: body, header: ["Content-Type": "application/json; charset=utf-8"])
                    MockWebServiceURLProtocol.cannedResponse(response)
                }
                
                afterEach {
                    MockWebServiceURLProtocol.cannedResponse(nil)
                }
                
                it("should complete on the main thread with no schedules and no error") {
                    provider.getNextPredictionsWithStopNo(56, managedObjectContext: moc, {
                        schedules, error -> Void in
                        
                        completionSchedules = schedules
                        completionError = error
                        })
                    
                    expect{completionSchedules}.will.beEmpty()
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
                
                it("should complete on the main thread with an error an no schedules") {
                    provider.getNextPredictionsWithStopNo(56, managedObjectContext: moc, {
                        schedules, error -> Void in
                        
                        completionSchedules = schedules
                        completionError = error
                        })
                    
                    expect{completionSchedules}.will.beNil()
                    expect{completionError}.will.equal(error)
                }
            }
        }
    }
}
