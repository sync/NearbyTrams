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
                    expect(stop).notTo(beNil())
                }
                
                it("should be a member of the Route class") {
                    expect(stop.isMemberOfClass(Stop)).to(beTruthy())
                }
            }
            
            describe("configureWithDictionaryFromRest") {
                beforeEach {
                    stop = Stop.insertInManagedObjectContext(moc) as Stop
                }
                
                context("with valid values") {
                    beforeEach {
                        var json: Dictionary<String, AnyObject> = [ : ]
                        json["Description"] = "a description"
                        json["Latitude"] = -36.45
                        json["Longitude"] = 145.68
                        json["StopName"] = "Burke Rd / Canterbury Rd"
                        json["StopNo"] = 14
                        json["SuburbName"] = "Canterbury"
                        json["UpStop"] = true
                        
                        stop.configureWithDictionaryFromRest(json)
                    }
                    
                    it("should have a Description") {
                        expect(stop.stopDescription).to(equal("a description"))
                    }
                    
                    it("should have a Latitude") {
                        expect(stop.latitude).to(equal(-36.45))
                    }
                    
                    it("should be a Longitude") {
                        expect(stop.longitude).to(equal(145.68))
                    }
                    
                    it("should have a name") {
                        expect(stop.name).to(equal("Burke Rd / Canterbury Rd"))
                    }
                    
                    it("should have a StopNo") {
                        expect(stop.stopNo).to(equal(14))
                    }
                    
                    it("should have a Suburb") {
                        expect(stop.suburb).to(equal("Canterbury"))
                    }
                    
                    it("should be an up stop") {
                        expect(stop.isUpStop).to(beTruthy())
                    }
                }
                
                context("with invalid values") {
                    beforeEach {
                        var json: Dictionary<String, AnyObject> = [ : ]
                        json["Description"] = NSNull()
                        json["Latitude"] = NSNull()
                        json["Longitude"] = 15
                        json["StopName"] = NSNull()
                        json["StopNo"] = "14"
                        json["SuburbName"] = NSNull()
                        json["UpStop"] = NSNull()
                        
                        stop.configureWithDictionaryFromRest(json)
                    }
                    
                    it("should have a Description") {
                        expect(stop.stopDescription).to(beNil())
                    }
                    
                    it("should have a Latitude") {
                        expect(stop.latitude).to(beNil())
                    }
                    
                    it("should be a Longitude") {
                        expect(stop.longitude).to(equal(15.00))
                    }
                    
                    it("should have a name") {
                        expect(stop.name).to(beNil())
                    }
                    
                    it("should have a StopNo") {
                        expect(stop.stopNo).to(beNil())
                    }
                    
                    it("should have a Suburb") {
                        expect(stop.suburb).to(beNil())
                    }
                    
                    it("should not be an up stop") {
                        expect(stop.isUpStop).to(beFalsy())
                    }
                }
            }
            
            describe("configureWithPartialDictionaryFromRest") {
                beforeEach {
                    stop = Stop.insertInManagedObjectContext(moc) as Stop
                }
                
                context("with valid values") {
                    beforeEach {
                        var fullJson: Dictionary<String, AnyObject> = [ : ]
                        fullJson["Description"] = "a description"
                        fullJson["Latitude"] = -36.45
                        fullJson["Longitude"] = 145.68
                        fullJson["StopName"] = "Burke Rd / Canterbury Rd"
                        fullJson["StopNo"] = 14
                        fullJson["SuburbName"] = "Canterbury"
                        fullJson["UpStop"] = true
                        
                        stop.configureWithDictionaryFromRest(fullJson)
                        
                        var json: Dictionary<String, AnyObject> = [ : ]
                        json["CityDirection"] = "from city"
                        json["Latitude"] = 0
                        json["Longitude"] = 0
                        json["StopName"] = "Rathmines Rd / Canterbury Rd"
                        json["Zones"] = "1"
                        
                        stop.configureWithPartialDictionaryFromRest(json)
                    }
                    
                    it("should have a CityDirection") {
                        expect(stop.cityDirection).to(equal("from city"))
                    }
                    
                    it("should have a Zones") {
                        expect(stop.zones).to(equal("1"))
                    }
                    
                    it("should have a Description") {
                        expect(stop.stopDescription).to(equal("a description"))
                    }
                    
                    it("should have a Latitude") {
                        expect(stop.latitude).to(equal(-36.45))
                    }
                    
                    it("should be a Longitude") {
                        expect(stop.longitude).to(equal(145.68))
                    }
                    
                    it("should have a name") {
                        expect(stop.name).to(equal("Burke Rd / Canterbury Rd"))
                    }
                    
                    it("should have a StopNo") {
                        expect(stop.stopNo).to(equal(14))
                    }
                    
                    it("should have a Suburb") {
                        expect(stop.suburb).to(equal("Canterbury"))
                    }
                }
            }
            
            describe("nextScheduledArrivalDates") {
                beforeEach {
                    stop = Stop.insertInManagedObjectContext(moc) as Stop
                    stop.uniqueIdentifier = "2789"
                    
                    moc.save(nil)
                }
                
                context("with no schedule") {
                    it ("should have no arrival dates") {
                        expect(stop.nextScheduledArrivalDates).to(beEmpty())
                    }
                }
                
                context("with a schedule but no predicted arrival date") {
                    var arrivalDates: [NSDate]?
                    
                    beforeEach {
                        let schedule1 = Schedule.insertInManagedObjectContext(moc) as Schedule
                        schedule1.uniqueIdentifier = "unique-identifier-1"
                        schedule1.stop = stop
                        
                        moc.save(nil)
                    }
                    
                    it ("should have no arrival dates") {
                        expect(stop.nextScheduledArrivalDates).to(beEmpty())
                    }
                }
                
                context("with schedules and predicted arrival dates") {
                    var firstDate: NSDate?
                    var lastDate: NSDate?
                    
                    beforeEach {
                        let schedule1 = Schedule.insertInManagedObjectContext(moc) as Schedule
                        schedule1.uniqueIdentifier = "unique-identifier-1"
                        schedule1.predictedArrivalDateTime = NSDate.distantFuture() as? NSDate
                        schedule1.stop = stop
                        
                        let schedule2 = Schedule.insertInManagedObjectContext(moc) as Schedule
                        schedule2.uniqueIdentifier = "unique-identifier-2"
                        schedule2.predictedArrivalDateTime = NSDate()
                        schedule2.stop = stop
                        
                        let schedule3 = Schedule.insertInManagedObjectContext(moc) as Schedule
                        schedule3.uniqueIdentifier = "unique-identifier-3"
                        schedule3.predictedArrivalDateTime = NSDate(timeIntervalSinceNow: 140)
                        schedule3.stop = stop
                        lastDate = schedule3.predictedArrivalDateTime
                        
                        let schedule4 = Schedule.insertInManagedObjectContext(moc) as Schedule
                        schedule4.uniqueIdentifier = "unique-identifier-4"
                        schedule4.predictedArrivalDateTime = NSDate(timeIntervalSinceNow: 14)
                        schedule4.stop = stop
                        firstDate = schedule4.predictedArrivalDateTime
                        
                        let schedule5 = Schedule.insertInManagedObjectContext(moc) as Schedule
                        schedule5.uniqueIdentifier = "unique-identifier-5"
                        schedule5.predictedArrivalDateTime = NSDate(timeIntervalSinceNow: 24)
                        schedule5.stop = stop
                        
                        moc.save(nil)
                    }
                    
                    it ("should have 3 arrival dates") {
                        expect(stop.nextScheduledArrivalDates?.count).to(equal(3))
                    }
                    
                    it ("should be ordered") {
                        expect(stop.nextScheduledArrivalDates![0]).to(equal(firstDate))
                        expect(stop.nextScheduledArrivalDates![2]).to(equal(lastDate))
                    }
                }
            }
        }
        
        // InsertAndFetchManagedObject, RESTManagedObject conformance is based on generics
        // Behaviour is tested inside RouteSpec
        // There is no reason to do it again here
    }
}
