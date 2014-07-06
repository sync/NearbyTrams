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
            
            networkService = NetworkService(baseURL: NSURL(string: "mock://www.apple.com"))
            provider = SchedulesProvider(networkService: networkService, managedObjectContext: moc)
            
            repository = SchedulesRepository(stopNo: 2166, schedulesProvider: provider, managedObjectContext: moc)
            fakeDelegate = SchedulesRepositoryFakeDelegate()
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
            
            describe("schedulesRepositoryLoadingStateDidChange") {
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
            
            describe("schedulesRepositoryDidFinsishLoading") {
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
