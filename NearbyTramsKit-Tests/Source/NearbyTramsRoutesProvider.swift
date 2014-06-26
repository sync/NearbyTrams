//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsKit

class NearbyTramsRoutesProviderSpec: QuickSpec {
    override func spec() {
        var provider: NearbyTramsRoutesProvider!
        
        describe("A provider function called alwaysTrue") {
            beforeEach() {
                provider = NearbyTramsRoutesProvider()
            }
            
            it ("should be true") {
                expect(provider.alwaysTrue()).to.beTrue()
            }
        }
    }
}
