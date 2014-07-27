//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsStorageKit

class NSDateDotNetSpec: QuickSpec {
    override func spec() {
        describe("Date From Dot Net") {
            var date: NSDate!
            
            context("with an invalid date") {
                beforeEach {
                    date = NSDate.fromDonet("aaa")
                }
                
                it("should not return a date") {
                    expect(date).to(beNil())
                }
            }
            
            context("with a valid date") {
                var expectedDate: NSDate?
                
                beforeEach {
                    date = NSDate.fromDonet("/Date(1388977800000+1000)/")
                    
                    let gregorian = NSCalendar(identifier: NSGregorianCalendar)
                    let components = NSDateComponents()
                    components.year = 2014
                    components.month = 1
                    components.day = 6
                    components.hour = 14
                    components.minute = 10
                    components.second = 0
                    components.timeZone = NSTimeZone.defaultTimeZone()
                    expectedDate = gregorian.dateFromComponents(components)
                }
                
                it("should return a valid date") {
                    expect(date).to(equal(expectedDate))
                }
            }
        }
        
        describe("Do Net Formatted String") {
            var string: NSString!
            
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
                let date = gregorian.dateFromComponents(components)
                
                string = date.dotNetFormattedString()
            }
            
            it("should return a valid string") {
                expect(string).to(equal("/Date(1388977800000+1000)/"))
            }
        }
    }
}
