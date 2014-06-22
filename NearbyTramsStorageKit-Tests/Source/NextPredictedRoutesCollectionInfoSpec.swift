//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsStorageKit

class NextPredictedRoutesCollectionInfoSpec: QuickSpec {
    override func spec() {
        describe("A Prediction") {
            var store: CoreDataTestsHelperStore!
            var moc: NSManagedObjectContext!
            var prediction: NextPredictedRoutesCollectionInfo!
            
            beforeEach {
                store = CoreDataTestsHelperStore()
                moc = store.managedObjectContext
            }
            
            afterEach {
                let success = moc.save(nil)
            }
            
            describe("insertInManagedObjectContext") {
                beforeEach {
                    prediction = NextPredictedRoutesCollectionInfo.insertInManagedObjectContext(moc)
                }
                
                it("should be non nil") {
                    expect(prediction).notTo.beNil()
                }
                
                it("should be a member of the Route class") {
                    expect(prediction.isMemberOfClass(NextPredictedRoutesCollectionInfo)).to.beTrue()
                }
            }
            
            describe("configureWithDictionaryFromRest") {
                beforeEach {
                    prediction = NextPredictedRoutesCollectionInfo.insertInManagedObjectContext(moc)
                }
                
                context("with valid values") {
                    var date: NSDate!
                    
                    beforeEach {
                        let gregorian = NSCalendar(identifier: NSGregorianCalendar)
                        let components = NSDateComponents()
                        components.year = 2014
                        components.month = 1
                        components.day = 6
                        components.hour = 14
                        components.minute = 10
                        components.second = 0
                        components.timeZone = NSTimeZone.defaultTimeZone()
                        date = gregorian.dateFromComponents(components)
                        let dotNetDate: NSString = date.dotNetFormattedString()
                        
                        let json: Dictionary<String, AnyObject> = [
                            "AirConditioned": true,
                            "Destination": "Sth Melb Beach",
                            "DisplayAC": true,
                            "DisruptionMessage": [
                                "DisplayType": "Text",
                                "MessageCount": 2,
                                "Messages": ["Message 1", "Message 2"]
                            ],
                            "HasDisruption": true,
                            "HasSpecialEvent": true,
                            "HeadBoardRouteNo": "1",
                            "InternalRouteNo": 1,
                            "IsLowFloorTram": true,
                            "IsTTAvailable": true,
                            "PredictedArrivalDateTime": dotNetDate,
                            "RouteNo": "1",
                            "SpecialEventMessage": "a special message",
                            "TripID": 10,
                            "VehicleNo": 2101
                        ]
                        
                        prediction.configureWithDictionaryFromRest(json)
                    }
                    
                    it("should be AirConditioned") {
                        expect(prediction.airConditioned).to.beTrue()
                    }
                    
                    it("should have a Destination") {
                        expect(prediction.destination).to.equal("Sth Melb Beach")
                    }
                    
                    it("should have a DisplayAC") {
                        expect(prediction.displayAC).to.beTrue()
                    }
                    
                    it("should have a DisruptionMessage") {
                        let disruptionMessage = [
                            "DisplayType": "Text",
                            "MessageCount": 2,
                            "Messages": ["Message 1", "Message 2"]
                        ]
                        expect(prediction.disruptionMessage).to.equal(disruptionMessage)
                    }
                    
                    it("should be of kind HasDisruption") {
                        expect(prediction.hasDisruption).to.beTrue()
                    }
                    
                    it("should be of kind HasSpecialEvent") {
                        expect(prediction.hasSpecialEvent).to.beTrue()
                    }
                    
                    it("should have a HeadBoardRouteNo") {
                        expect(prediction.headBoardRouteNo).to.equal("1")
                    }
                    
                    it("should have a InternalRouteNo") {
                        expect(prediction.internalRouteNo).to.equal(1)
                    }
                    
                    it("should be a IsLowFloorTram") {
                        expect(prediction.isLowFloorTram).to.beTrue()
                    }
                    
                    it("should have a IsTTAvailable") {
                        expect(prediction.isTTAvailable).to.beTrue()
                    }
                    
                    it("should have a PredictedArrivalDateTime") {
                        expect(prediction.predictedArrivalDateTime).to.equal(date)
                    }
                    
                    it("should have a RouteNo") {
                        expect(prediction.routeNo).to.equal("1")
                    }
                    
                    it("should have a SpecialEventMessage") {
                        expect(prediction.specialEventMessage).to.equal("a special message")
                    }
                    
                    it("should have a TripID") {
                        expect(prediction.tripID).to.equal(10)
                    }
                    
                    it("should have a VehicleNo") {
                        expect(prediction.vehicleNo).to.equal(2101)
                    }
                }
                
                context("with invalid values") {
                    beforeEach {
                        let json: Dictionary<String, AnyObject> = [ : ]
                        
                        prediction.configureWithDictionaryFromRest(json)
                    }
                }
            }
        }
    }
}
