//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsKit
import NearbyTramsNetworkKit
import NearbyTramsStorageKit

class FakeRoutesViewModelDelegate: RoutesViewModelDelegate
{
    var addedRoutes: RouteViewModel[]?
    var removedRoutes: RouteViewModel[]?
    var updatedRoutes: RouteViewModel[]?
    
    func routesViewModelDidAddRoutes(routesViewModel: RoutesViewModel, routes: RouteViewModel[])
    {
        addedRoutes = routes
    }
    
    func routesViewModelDidRemoveRoutes(routesViewModel: RoutesViewModel, routes: RouteViewModel[])
    {
        removedRoutes = routes
    }
    
    func routesViewModelDidUpdateRoutes(routesViewModel: RoutesViewModel, routes: RouteViewModel[])
    {
        updatedRoutes = routes
    }
}

class RoutesViewModelSpec: QuickSpec {
    override func spec() {
        
        var store: CoreDataTestsHelperStore!
        var moc: NSManagedObjectContext!
        
        var fakeDelegate: FakeRoutesViewModelDelegate!
        var viewModel: RoutesViewModel!
        
        var fetchRequest: NSFetchRequest!
        
        beforeEach {
            store = CoreDataTestsHelperStore()
            moc = store.managedObjectContext
            
            viewModel = RoutesViewModel(managedObjectContext: moc)
            fakeDelegate = FakeRoutesViewModelDelegate()
            viewModel.delegate = fakeDelegate
            
            fetchRequest = NSFetchRequest(entityName: Route.entityName)
            viewModel.startUpdatingRoutesWithFetchRequest(fetchRequest)
        }
        
        afterEach {
            let success = moc.save(nil)
        }
        
        context("when empty") {
            it("should have no routes") {
                expect(viewModel.routes).to.beEmpty()
            }
            
            it("should have per routes count zero") {
                expect(viewModel.routesCount).to.equal(0)
            }
        }
        
        describe("Adding routes") {
            context("when adding one route") {
                beforeEach {
                    let route: Route = Route.insertInManagedObjectContext(moc)
                    route.routeNo = 123
                    route.uniqueIdentifier = "123-true"
                    route.name = "name"
                    moc.save(nil)
                }
                
                it("should have one routes") {
                    expect(viewModel.routes.count).to.equal(1)
                }
                
                it("should have per routes count one") {
                    expect(viewModel.routesCount).to.equal(1)
                }
                
                it("should tell delegate about the added route") {
                    expect(fakeDelegate.addedRoutes?[0].identifier).to.equal("123-true")
                }
            }
            
            context("when adding one invalid route") {
                beforeEach {
                    let route: Route = Route.insertInManagedObjectContext(moc)
                    moc.save(nil)
                }
                
                it("should have no routes") {
                    expect(viewModel.routes).to.beEmpty()
                }
                
                it("should have per routes count zero") {
                    expect(viewModel.routesCount).to.equal(0)
                }
            }
            
            context("when adding multiple routes") {
                beforeEach {
                    let route1: Route = Route.insertInManagedObjectContext(moc)
                    route1.routeNo = 123
                    route1.uniqueIdentifier = "123-true"
                    route1.name = "a name"
                    
                    let route2: Route = Route.insertInManagedObjectContext(moc)
                    route2.routeNo = 456
                    route2.uniqueIdentifier = "456-false"
                    route2.name = "another name"
                    
                    moc.save(nil)
                }
                
                it("should have one routes") {
                    expect(viewModel.routes.count).to.equal(2)
                }
                
                it("should have per routes count one") {
                    expect(viewModel.routesCount).to.equal(2)
                }
                
                it("should tell delegate about the two added route") {
                    let identifiers = [fakeDelegate.addedRoutes![0].identifier, fakeDelegate.addedRoutes![1].identifier]
                    expect(identifiers).to.contain("123-true")
                    expect(identifiers).to.contain("456-false")
                }
            }
        }
        
        describe("Removing routes") {
            var route1: Route!
            var route2: Route!
            
            beforeEach {
                route1 = Route.insertInManagedObjectContext(moc) as Route
                route1.routeNo = 123
                route1.uniqueIdentifier = "123-true"
                route1.name = "a name"
                
                route2 = Route.insertInManagedObjectContext(moc) as Route
                route2.routeNo = 456
                route2.uniqueIdentifier = "456-false"
                route2.name = "another name"
                
                moc.save(nil)
            }
            
            context("when removing one route") {
                beforeEach {
                    moc.deleteObject(route1)
                    moc.save(nil)
                }
                
                it("should have one routes") {
                    expect(viewModel.routes[0].identifier).to.equal("456-false")
                }
                
                it("should have per routes count one") {
                    expect(viewModel.routesCount).to.equal(1)
                }
                
                it("should tell delegate about the removed route") {
                     expect(fakeDelegate.removedRoutes?[0].identifier).to.equal("123-true")
                }
            }
            
            context("when removing multiple routes") {
                beforeEach {
                    moc.deleteObject(route1)
                    moc.deleteObject(route2)
                    moc.save(nil)
                }
                
                it("should have one routes") {
                    expect(viewModel.routes.count).to.equal(0)
                }
                
                it("should have per routes count one") {
                    expect(viewModel.routesCount).to.equal(0)
                }
                
                it("should tell delegate about the two removed route") {
                    let identifiers = [fakeDelegate.removedRoutes![0].identifier, fakeDelegate.removedRoutes![1].identifier]
                    expect(identifiers).to.contain("123-true")
                    expect(identifiers).to.contain("456-false")
                }
            }
        }
        
        describe("Updating routes") {
            var route1: Route!
            var route2: Route!
            
            beforeEach {
                route1 = Route.insertInManagedObjectContext(moc) as Route
                route1.routeNo = 123
                route1.uniqueIdentifier = "123-true"
                route1.name = "a name"
                
                route2 = Route.insertInManagedObjectContext(moc) as Route
                route2.routeNo = 456
                route2.uniqueIdentifier = "456-false"
                route2.name = "another name"
                
                moc.save(nil)
            }
            
            context("when updating one route") {
                beforeEach {
                    route1.name = "new name"
                    
                    moc.save(nil)
                }
                
                it("should tell delegate about the updated route") {
                     expect(fakeDelegate.updatedRoutes?[0].name).to.equal("new name")
                }
            }
            
            context("when updating multiple routes") {
                beforeEach {
                    route1.name = "new name"
                    route2.name = "another new name"
                    
                    moc.save(nil)
                }
                
                it("should tell delegate about the two updated route") {
                    let names = [fakeDelegate.updatedRoutes![0].name, fakeDelegate.updatedRoutes![1].name]
                    expect(names).to.contain("new name")
                    expect(names).to.contain("another new name")
                }
            }
            
            context("when one update to a route invalidate it's corresponding view model") {
                beforeEach {
                    route1.name = nil
                    
                    moc.save(nil)
                }
                
                it("should have per routes count one") {
                    expect(viewModel.routesCount).to.equal(1)
                }
                
                it("should tell delegate about the removed route") {
                    expect(fakeDelegate.removedRoutes?[0].identifier).to.equal("123-true")
                }
            }
        }
        
        
        describe("stopUpdatingRoutes") {
            beforeEach {
                viewModel.stopUpdatingRoutes()
                
                let route1: Route = Route.insertInManagedObjectContext(moc)
                route1.routeNo = 123
                route1.uniqueIdentifier = "123-true"
                route1.name = "a name"
                moc.save(nil)
            }
            
            it("should not tell delegate about the two added route") {
                expect(fakeDelegate.addedRoutes?.count).to.beNil()
            }
        }
        
        describe("reconfiguring startUpdatingRoutesWithFetchRequest") {
            context("when adding one route") {
                beforeEach {
                    let route1: Route = Route.insertInManagedObjectContext(moc)
                    route1.routeNo = 123
                    route1.uniqueIdentifier = "123-true"
                    route1.name = "a name"
                    
                    let route2: Route = Route.insertInManagedObjectContext(moc)
                    route2.routeNo = 456
                    route2.uniqueIdentifier = "456-false"
                    route2.name = "another name"
                    
                    moc.save(nil)
                    
                    fetchRequest = NSFetchRequest(entityName: Route.entityName)
                    fetchRequest.predicate = NSPredicate(format:"uniqueIdentifier == %@", "123-true")
                    viewModel.startUpdatingRoutesWithFetchRequest(fetchRequest)
                    
                    let route3: Route = Route.insertInManagedObjectContext(moc)
                    route3.routeNo = 789
                    route3.uniqueIdentifier = "789-true"
                    route3.name = "a third name"
                    
                    moc.save(nil)
                }
                
                it("should have one routes") {
                    expect(viewModel.routes.count).to.equal(1)
                }
                
                it("should have per routes count one") {
                    expect(viewModel.routesCount).to.equal(1)
                }
                
                it("should tell delegate about the added routes") {
                    let identifiers = [fakeDelegate.addedRoutes![0].identifier, fakeDelegate.addedRoutes![1].identifier]
                    expect(identifiers).to.contain("123-true")
                    expect(identifiers).to.contain("456-false")
                }
                
                it("should tell delegate about the updated route") {
                     expect(fakeDelegate.updatedRoutes?[0].identifier).to.equal("123-true")
                }
                
                it("should tell delegate about the removed route") {
                    expect(fakeDelegate.removedRoutes?[0].identifier).to.equal("456-false")
                }
            }
        }
    }
}
