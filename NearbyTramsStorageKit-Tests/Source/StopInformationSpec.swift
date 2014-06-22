//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsStorageKit

class StopInformationSpec: QuickSpec {
    override func spec() {
        describe("A Stop Information") {
            var store: CoreDataTestsHelperStore!
            var moc: NSManagedObjectContext!
            var stopInformation: StopInformation!
            
            beforeEach {
                store = CoreDataTestsHelperStore()
                moc = store.managedObjectContext
            }
            
            afterEach {
                let success = moc.save(nil)
            }
            
            describe("insertInManagedObjectContext") {
                beforeEach {
                    stopInformation = StopInformation.insertInManagedObjectContext(moc)
                }
                
                it("should be non nil") {
                    expect(stopInformation).notTo.beNil()
                }
                
                it("should be a member of the Route class") {
                    expect(stopInformation.isMemberOfClass(StopInformation)).to.beTrue()
                }
            }
            
            describe("configureWithDictionaryFromRest") {
                beforeEach {
                    stopInformation = StopInformation.insertInManagedObjectContext(moc)
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
                            "DistanceToLocation": 14.00,
                            "Latitude": -36.45,
                            "Longitude": 145.68,
                        ]
                        
                        stopInformation.configureWithDictionaryFromRest(json)
                    }
                    
                    it("should have a CityDirection") {
                        expect(stopInformation.cityDirection).to.equal("a city direction")
                    }
                    
                    it("should have a Description") {
                        expect(stopInformation.stopDescription).to.equal("a description")
                    }
                    
                    it("should have a Destination") {
                        expect(stopInformation.destination).to.equal("a destination")
                    }
                    
                    it("should have a FlagStopNo") {
                        expect(stopInformation.flagStopNo).to.equal("Stop 965a")
                    }
                    
                    it("should have a RouteNo") {
                        expect(stopInformation.routeNo).to.equal(5)
                    }
                    
                    it("should have a StopID") {
                        expect(stopInformation.stopID).to.equal("567aab")
                    }
                    
                    it("should have a StopName") {
                        expect(stopInformation.stopName).to.equal("Burke Rd / Canterbury Rd")
                    }
                    
                    it("should have a StopNo") {
                        expect(stopInformation.stopNo).to.equal(14)
                    }
                    
                    it("should have a Suburb") {
                        expect(stopInformation.suburb).to.equal("Canterbury")
                    }
                    
                    it("should have a DistanceToLocation") {
                        expect(stopInformation.distanceToLocation).to.equal(14.00)
                    }
                    
                    it("should have a Latitude") {
                        expect(stopInformation.latitude).to.equal(-36.45)
                    }
                    
                    it("should be a Longitude") {
                        expect(stopInformation.longitude).to.equal(145.68)
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
                        
                        stopInformation.configureWithDictionaryFromRest(json)
                    }
                    
                    it("should have a CityDirection") {
                        expect(stopInformation.cityDirection).to.beNil()
                    }
                    
                    it("should have a Description") {
                        expect(stopInformation.stopDescription).to.beNil()
                    }
                    
                    it("should have a Destination") {
                        expect(stopInformation.destination).to.beNil()
                    }
                    
                    it("should have a FlagStopNo") {
                        expect(stopInformation.flagStopNo).to.beNil()
                    }
                    
                    it("should have a RouteNo") {
                        expect(stopInformation.routeNo).to.beNil()
                    }
                    
                    it("should have a StopID") {
                        expect(stopInformation.stopID).to.beNil()
                    }
                    
                    it("should have a StopName") {
                        expect(stopInformation.stopName).to.beNil()
                    }
                    
                    it("should have a StopNo") {
                        expect(stopInformation.stopNo).to.beNil()
                    }
                    
                    it("should have a Suburb") {
                        expect(stopInformation.suburb).to.beNil()
                    }
                    
                    it("should have a DistanceToLocation") {
                        expect(stopInformation.distanceToLocation).to.beNil()
                    }
                    
                    it("should have a Latitude") {
                        expect(stopInformation.latitude).to.beNil()
                    }
                    
                    it("should be a Longitude") {
                        expect(stopInformation.longitude).to.equal(15.00)
                    }
                }
            }
        }
    }
}
