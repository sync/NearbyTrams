//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsStorageKit

class StopSpec: QuickSpec {
    override func spec() {
        describe("A Stop") {
            var store: CoreDataTestsHelperStore!
            var moc: NSManagedObjectContext!
            var stop: Stop!
            
            beforeEach {
                store = CoreDataTestsHelperStore()
                moc = store.managedObjectContext
            }
            
            afterEach {
                let success = moc.save(nil)
            }
            
            describe("insertInManagedObjectContext") {
                beforeEach {
                    stop = Stop.insertInManagedObjectContext(moc) as Stop
                }
                
                it("should be non nil") {
                    expect(stop).notTo.beNil()
                }
                
                it("should be a member of the Route class") {
                    expect(stop.isMemberOfClass(Stop)).to.beTrue()
                }
            }
            
            describe("configureWithDictionaryFromRest") {
                beforeEach {
                    stop = Stop.insertInManagedObjectContext(moc) as Stop
                }
                
                context("with valid values") {
                    beforeEach {
                        var json: Dictionary<String, AnyObject> = [
                            "CityDirection": "a city direction",
                            "Description": "a description",
                            "Destination": "a destination",
                            "FlagStopNo": "Stop 965a",
                            "RouteNo": 5,
                            "StopID": "567aab",
                            "StopName": "Burke Rd / Canterbury Rd",
                            "StopNo": 14,
                            "Suburb": "Canterbury",
                            "DistanceToLocation": 14,
                            "Latitude": -36,
                            "Longitude": 145,
                        ]
                        
                        stop.configureWithDictionaryFromRest(json)
                    }
                    
                    it("should have a CityDirection") {
                        expect(stop.cityDirection).to.equal("a city direction")
                    }
                    
                    it("should have a Description") {
                        expect(stop.stopDescription).to.equal("a description")
                    }
                    
                    it("should have a Destination") {
                        expect(stop.destination).to.equal("a destination")
                    }
                    
                    it("should have a FlagStopNo") {
                        expect(stop.flagStopNo).to.equal("Stop 965a")
                    }
                    
                    it("should have a RouteNo") {
                        expect(stop.routeNo).to.equal(5)
                    }
                    
                    it("should have a StopID") {
                        expect(stop.stopID).to.equal("567aab")
                    }
                    
                    it("should have a StopName") {
                        expect(stop.stopName).to.equal("Burke Rd / Canterbury Rd")
                    }
                    
                    it("should have a StopNo") {
                        expect(stop.stopNo).to.equal(14)
                    }
                    
                    it("should have a Suburb") {
                        expect(stop.suburb).to.equal("Canterbury")
                    }
                    
                    it("should have a DistanceToLocation") {
                        expect(stop.distanceToLocation).to.equal(14.00)
                    }
                    
                    it("should have a Latitude") {
                        expect(stop.latitude).to.equal(-36)
                    }
                    
                    it("should be a Longitude") {
                        expect(stop.longitude).to.equal(145)
                    }
                }

                context("with invalid values") {
                    beforeEach {
                        var json: Dictionary<String, AnyObject> = [
                            "CityDirection": NSNull(),
                            "Description": NSNull(),
                            "Destination": NSNull(),
                            "FlagStopNo": NSNull(),
                            "RouteNo": "5",
                            "StopID": NSNull(),
                            "StopName": NSNull(),
                            "StopNo": "14",
                            "Suburb": NSNull(),
                            "DistanceToLocation": NSNull(),
                            "Latitude": NSNull(),
                            "Longitude": 15,
                        ]
                        
                        stop.configureWithDictionaryFromRest(json)
                    }
                    
                    it("should have a CityDirection") {
                        expect(stop.cityDirection).to.beNil()
                    }
                    
                    it("should have a Description") {
                        expect(stop.stopDescription).to.beNil()
                    }
                    
                    it("should have a Destination") {
                        expect(stop.destination).to.beNil()
                    }
                    
                    it("should have a FlagStopNo") {
                        expect(stop.flagStopNo).to.beNil()
                    }
                    
                    it("should have a RouteNo") {
                        expect(stop.routeNo).to.beNil()
                    }
                    
                    it("should have a StopID") {
                        expect(stop.stopID).to.beNil()
                    }
                    
                    it("should have a StopName") {
                        expect(stop.stopName).to.beNil()
                    }
                    
                    it("should have a StopNo") {
                        expect(stop.stopNo).to.beNil()
                    }
                    
                    it("should have a Suburb") {
                        expect(stop.suburb).to.beNil()
                    }
                    
                    it("should have a DistanceToLocation") {
                        expect(stop.distanceToLocation).to.beNil()
                    }
                    
                    it("should have a Latitude") {
                        expect(stop.latitude).to.beNil()
                    }
                    
                    it("should be a Longitude") {
                        expect(stop.longitude).to.equal(15.00)
                    }
                }
            }
            
            describe("configureWithPartialDictionaryFromRest") {
                beforeEach {
                    stop = Stop.insertInManagedObjectContext(moc) as Stop
                }
                
                context("with valid values") {
                    beforeEach {
                        var fullJson: Dictionary<String, AnyObject> = [
                            "CityDirection": "a city direction",
                            "Description": "a description",
                            "Destination": "a destination",
                            "FlagStopNo": "Stop 965a",
                            "RouteNo": 5,
                            "StopID": "567aab",
                            "StopName": "Burke Rd / Canterbury Rd",
                            "StopNo": 14,
                            "Suburb": "Canterbury",
                            "DistanceToLocation": 14,
                            "Latitude": -36,
                            "Longitude": 145,
                        ]
                        
                        stop.configureWithDictionaryFromRest(fullJson)
                        
                        var json: Dictionary<String, AnyObject> = [
                            "CityDirection": "from city",
                            "Description": NSNull(),
                            "Destination": NSNull(),
                            "FlagStopNo": "66",
                            "RouteNo": 0,
                            "StopID": NSNull(),
                            "StopName": "Rathmines Rd / Canterbury Rd",
                            "StopNo": 0,
                            "Suburb": NSNull(),
                            "DistanceToLocation": 0,
                            "Latitude": 0,
                            "Longitude": 0,
                        ]
                        
                        stop.configureWithPartialDictionaryFromRest(json)
                    }
                    
                    it("should have a CityDirection") {
                        expect(stop.cityDirection).to.equal("from city")
                    }
                    
                    it("should have a Description") {
                        expect(stop.stopDescription).to.equal("a description")
                    }
                    
                    it("should have a Destination") {
                        expect(stop.destination).to.equal("a destination")
                    }
                    
                    it("should have a FlagStopNo") {
                        expect(stop.flagStopNo).to.equal("66")
                    }
                    
                    it("should have a RouteNo") {
                        expect(stop.routeNo).to.equal(5)
                    }
                    
                    it("should have a StopID") {
                        expect(stop.stopID).to.equal("567aab")
                    }
                    
                    it("should have a StopName") {
                        expect(stop.stopName).to.equal("Rathmines Rd / Canterbury Rd")
                    }
                    
                    it("should have a StopNo") {
                        expect(stop.stopNo).to.equal(14)
                    }
                    
                    it("should have a Suburb") {
                        expect(stop.suburb).to.equal("Canterbury")
                    }
                    
                    it("should have a DistanceToLocation") {
                        expect(stop.distanceToLocation).to.equal(14.00)
                    }
                    
                    it("should have a Latitude") {
                        expect(stop.latitude).to.equal(-36)
                    }
                    
                    it("should be a Longitude") {
                        expect(stop.longitude).to.equal(145)
                    }
                }
            }
        }
        
        // InsertAndFetchManagedObject, RESTManagedObject conformance is based on generics
        // Behaviour is tested inside RouteSpec
        // There is no reason to do it again here
    }
}
