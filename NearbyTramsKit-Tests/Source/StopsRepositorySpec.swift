//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsKit
import NearbyTramsNetworkKit
import NearbyTramsStorageKit

class StopsRepositoryFakeDelegate: StopsRepositoryDelegate
{
    var loading: Bool
    var error: NSError?
    
    init()
    {
        self.loading = false
    }
    
    func stopsRepositoryLoadingStateDidChange(repository: StopsRepository, isLoading loading: Bool) -> Void
    {
        self.loading = loading
    }
    
    func stopsRepositoryDidFinsishLoading(repository: StopsRepository, error: NSError?) -> Void
    {
        self.error = error
    }
}

class StopsRepositorySpec: QuickSpec {
    override func spec() {
        
        var store: CoreDataTestsHelperStore!
        var moc: NSManagedObjectContext!
        
        var networkService: NetworkService!
        var provider: StopsProvider!
        
        var fakeDelegate: StopsRepositoryFakeDelegate!
        var repository: StopsRepository!
        
        beforeEach {
            store = CoreDataTestsHelperStore()
            moc = store.managedObjectContext
            
            let route: Route = Stop.insertInManagedObjectContext(moc)
            route.uniqueIdentifier = "66-true"
            route.routeNo = "66"
            route.isUpStop = true
            moc.save(nil)
            
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let urlProcolClass: AnyObject = ClassUtility.classFromType(MockWebServiceURLProtocol.self)
            configuration.protocolClasses = [urlProcolClass]
            networkService = NetworkService(baseURL: NSURL(string: "mock://www.apple.com"), configuration: configuration)
            provider = StopsProvider(networkService: networkService, managedObjectContext: moc)
            
            repository = StopsRepository(routeIdentifier: "66-true", stopsProvider: provider, managedObjectContext: moc)
            fakeDelegate = StopsRepositoryFakeDelegate()
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
                    expect(repository.isLoading).to.beTrue()
                }
            }
            
            context("when provider isn't loading") {
                it ("should be false") {
                    expect{repository.isLoading}.will.beFalse()
                }
            }
        }
        
        describe("update") {
            beforeEach {
                repository.update()
            }
            
            describe("stopsRepositoryLoadingStateDidChange") {
                context("when loading") {
                    it ("should be true") {
                        expect(fakeDelegate.loading).to.beTrue()
                    }
                }
                
                context("when isn't loading") {
                    it ("should be false") {
                        expect{fakeDelegate.loading}.will.beFalse()
                    }
                }
            }
            
            describe("stopsRepositoryDidFinsishLoading") {
                beforeEach {
                    repository.update()
                }
                
                context("when finish loading with an error") {
                    it ("should have an error") {
                        expect{fakeDelegate.error}.willNot.beNil()
                    }
                }
            }
        }
        
        describe("on success") {
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
                
                let responseGetStopBody = ["responseObject": [json1, json2]]
                let responseGetStop = MockWebServiceResponse(body: responseGetStopBody, header: ["Content-Type": "application/json; charset=utf-8"], urlComponentToMatch:"GetListOfStopsByRouteNoAndDirection")
                
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
                
                let responseGetStopInfoBody = ["responseObject": json1]
                let responseGetStopInfo = MockWebServiceResponse(body: responseGetStopInfoBody, header: ["Content-Type": "application/json; charset=utf-8"], urlComponentToMatch:"GetStopInformation")
                
                MockWebServiceURLProtocol.cannedResponses([responseGetStop, responseGetStopInfo])
                
                repository.update()
            }
            
            afterEach {
                MockWebServiceURLProtocol.cannedResponse(nil)
            }
            
            func fetchRoute() -> Route?
            {
                var result: (route: Route?, error:NSError?) = Route.fetchOneForPrimaryKeyValue("66-true", usingManagedObjectContext: moc)
                return result.route
            }
            
            it("should add stops and assign the to it's corresponding route") {
                expect{fetchRoute()?.stops.count}.will.equal(2)
            }
        }
    }
}
