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
            
            networkService = NetworkService(baseURL: NSURL(string: "mock://www.apple.com"))
            provider = StopsProvider(networkService: networkService, managedObjectContext: moc)
            
            repository = StopsRepository(routeNo: 66, stopsProvider: provider, managedObjectContext: moc)
            fakeDelegate = StopsRepositoryFakeDelegate()
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
    }
}
