//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsKit

class ColorUtilitySpec: QuickSpec {
    override func spec() {
        describe("when generating a random color") {
            var color1: CGColorRef!
            var color2: CGColorRef!
            
            beforeEach {
                color1 = ColorUtility.generateRandomColor()
                color2 = ColorUtility.generateRandomColor()
            }
            
            it("must be unique") {
                let colorsAreEqual = CGColorEqualToColor(color1, color2)
                expect(colorsAreEqual).notTo.beTrue()
            }
        }
    }
}
