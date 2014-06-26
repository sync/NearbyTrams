//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsKit

class FakeSpec: QuickSpec {
    override func spec() {
        describe("Fake") {
            it ("should be true") {
                let fakeClass = FakeClass()
                expect(fakeClass.alwaysTrue()).to.beTrue()
            }
        }
    }
}
