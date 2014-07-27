//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsKit
import NearbyTramsNetworkKit
import NearbyTramsStorageKit

class SchedulesRepositoryFakeDelegate: SchedulesRepositoryDelegate
{
    var loading: Bool
    var error: NSError?
    
    init()
    {
        self.loading = false
    }
    
    func schedulesRepositoryLoadingStateDidChange(repository: SchedulesRepository, isLoading loading: Bool) -> Void
    {
        self.loading = loading
    }
    
    func schedulesRepositoryDidFinsishLoading(repository: SchedulesRepository, error: NSError?) -> Void
    {
        self.error = error
    }
}

class SchedulesRepositorySpec: QuickSpec {
    override func spec() {
        
        var store: CoreDataTestsHelperStore!
        var moc: NSManagedObjectContext!
        
        var networkService: NetworkService!
        var provider: SchedulesProvider!
        
        var fakeDelegate: SchedulesRepositoryFakeDelegate!
        var repository: SchedulesRepository!
        
        beforeEach {
            store = CoreDataTestsHelperStore()
            moc = store.managedObjectContext
            
            let route: Route = Route.insertInManagedObjectContext(moc)
            route.uniqueIdentifier = "16-false"
            route.routeNo = "16"
            
            let stop: Stop = Stop.insertInManagedObjectContext(moc)
            stop.uniqueIdentifier = "2166"
            stop.stopNo = 2166
            stop.routes = NSMutableSet(array: [route])
            moc.save(nil)
            
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let urlProcolClass: AnyObject = ClassUtility.classFromType(MockWebServiceURLProtocol.self)
            configuration.protocolClasses = [urlProcolClass]
            networkService = NetworkService(baseURL: NSURL(string: "mock://www.apple.com"), configuration: configuration)
            provider = SchedulesProvider(networkService: networkService, managedObjectContext: moc)
            
            repository = SchedulesRepository(routeIdentifier: "16-false", stopIdentifier: "2166", schedulesProvider: provider, managedObjectContext: moc)
            fakeDelegate = SchedulesRepositoryFakeDelegate()
            repository.delegate = fakeDelegate
        }
        
        afterEach {
            let success = moc.save(nil)
        }
        
        describe("isLoading") {
            beforeEach {
                repository.update()
            }
            
            context("when provider is loading") {
                it ("should be true") {
                    expect(repository.isLoading).to(beTruthy())
                }
            }
            
            context("when provider isn't loading") {
                it ("should be false") {
                    expect{repository.isLoading}.toEventually(beFalsy())
                }
            }
        }
        
        describe("update") {
            beforeEach {
                repository.update()
            }
            
            describe("schedulesRepositoryLoadingStateDidChange") {
                context("when loading") {
                    it ("should be true") {
                        expect(fakeDelegate.loading).to(beTruthy())
                    }
                }
                
                context("when isn't loading") {
                    it ("should be false") {
                        expect{fakeDelegate.loading}.toEventually(beFalsy())
                    }
                }
            }
            
            describe("schedulesRepositoryDidFinsishLoading") {
                beforeEach {
                    repository.update()
                }
                
                context("when finish loading with an error") {
                    it ("should have an error") {
                        expect{fakeDelegate.error}.toEventuallyNot(beNil())
                    }
                }
            }
        }
        
        describe("on success") {
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
                
                repository.update()
            }
            
            afterEach {
                MockWebServiceURLProtocol.cannedResponse(nil)
            }
            
            func fetchStop() -> Stop?
            {
                var result: (stop: Stop?, error:NSError?) = Stop.fetchOneForPrimaryKeyValue("2166", usingManagedObjectContext: moc)
                return result.stop
            }
            
            it("should add schedules and assign the to it's corresponding stop") {
                expect{fetchStop()?.schedules.count}.toEventually(equal(1))
            }
        }
    }
}
