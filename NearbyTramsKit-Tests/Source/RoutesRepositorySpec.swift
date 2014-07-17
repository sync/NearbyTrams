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
            
            describe("routesRepositoryLoadingStateDidChange") {
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
            
            describe("routesRepositoryDidFinsishLoading") {
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
                let json1: NSDictionary = [
                    "RouteNumber": 5,
                    "Name": "Melbourne",
                    "IsUpStop": true
                ]
                
                let json2: NSDictionary = [
                    "RouteNumber": 10,
                    "Name": "Pyrmont",
                    "IsUpStop": false
                ]
                
                let body = ["ResponseObject": [json1, json2]]
                let response = MockWebServiceResponse(body: body, header: ["Content-Type": "application/json; charset=utf-8"])
                MockWebServiceURLProtocol.cannedResponse(response)
                
                repository.update()
            }
            
            afterEach {
                MockWebServiceURLProtocol.cannedResponse(nil)
            }
            
            it("should add routes") {
                let fetchRequest = NSFetchRequest(entityName: Route.entityName)
                expect{moc.executeFetchRequest(fetchRequest, error: nil).count}.will.equal(2)
            }
        }
    }
}
