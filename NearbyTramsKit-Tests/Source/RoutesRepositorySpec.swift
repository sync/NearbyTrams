//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsKit
import NearbyTramsNetworkKit
import NearbyTramsStorageKit

class RoutesRepositoryFakeDelegate: RoutesRepositoryDelegate
{
    var loading: Bool
    var error: NSError?
    
    init()
    {
        self.loading = false
    }
    
    func routesRepositoryLoadingStateDidChange(repository: RoutesRepository, isLoading loading: Bool) -> Void
    {
        self.loading = loading
    }
    
    func routesRepositoryDidFinsishLoading(repository: RoutesRepository, error: NSError?) -> Void
    {
        self.error = error
    }
}

class RoutesRepositorySpec: QuickSpec {
    override func spec() {
        
        var store: CoreDataTestsHelperStore!
        var moc: NSManagedObjectContext!
        
        var networkService: NetworkService!
        var provider: RoutesProvider!
        
        var fakeDelegate: RoutesRepositoryFakeDelegate!
        var repository: RoutesRepository!
        
        beforeEach {
            store = CoreDataTestsHelperStore()
            moc = store.managedObjectContext
            
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let urlProcolClass: AnyObject = ClassUtility.classFromType(MockWebServiceURLProtocol.self)
            configuration.protocolClasses = [urlProcolClass]
            networkService = NetworkService(baseURL: NSURL(string: "mock://www.apple.com"), configuration: configuration)
            provider = RoutesProvider(networkService: networkService, managedObjectContext: moc)
            
            repository = RoutesRepository(routesProvider: provider, managedObjectContext: moc)
            fakeDelegate = RoutesRepositoryFakeDelegate()
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
            
            describe("routesRepositoryLoadingStateDidChange") {
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
            
            describe("routesRepositoryDidFinsishLoading") {
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
                
                repository.update()
            }
            
            afterEach {
                MockWebServiceURLProtocol.cannedResponse(nil)
            }
            
            it("should add routes") {
                let fetchRequest = NSFetchRequest(entityName: Route.entityName)
                expect{moc.executeFetchRequest(fetchRequest, error: nil).count}.toEventually(equal(2))
            }
        }
    }
}
