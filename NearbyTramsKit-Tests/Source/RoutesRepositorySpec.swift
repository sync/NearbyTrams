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
            
            networkService = NetworkService(baseURL: NSURL(string: "mock://www.apple.com"))
            provider = RoutesProvider(networkService: networkService, managedObjectContext: moc)
            
            repository = RoutesRepository(routesProvider: provider, managedObjectContext: moc)
            fakeDelegate = RoutesRepositoryFakeDelegate()
            repository.delegate = fakeDelegate
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
    }
}
