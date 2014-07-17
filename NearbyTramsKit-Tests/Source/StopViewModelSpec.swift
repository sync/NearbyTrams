//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsKit

class StopViewModelSpec: QuickSpec {
    override func spec() {
        
        var viewModel: StopViewModel!
        
        describe("init") {
            context("when given a name") {
                var stopName: String!
                
                beforeEach {
                    stopName = "a stop name"
                    viewModel = StopViewModel(identifier: "an identifier", routeNo: 76, routeName: "a name",  isUpStop: true, stopNo: 45, stopName: stopName, schedules: nil)
                }
                
                it ("should remember it") {
                    expect(viewModel.stopName).to.equal(stopName)
                }
            }
        }
    }
}
