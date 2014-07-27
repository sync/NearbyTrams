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
                    viewModel = StopViewModel(identifier: "an identifier", routesNo: ["76"], stopDescription: "a description",  isUpStop: true, stopNo: 45, stopName: stopName, schedules: nil)
                }
                
                it ("should remember it") {
                    expect(viewModel.stopName).to(equal(stopName))
                }
            }
        }
        
        describe("equatable") {
            beforeEach {
                viewModel = StopViewModel(identifier: "an identifier", routesNo: ["76"], stopDescription: "a description",  isUpStop: true, stopNo: 45, stopName: "a stop name", schedules: nil)
            }
            
            context ("with the same identifiers") {
                it ("should be equal") {
                    var viewModelEqual = StopViewModel(identifier: "an identifier", routesNo: ["76"], stopDescription: "a description",  isUpStop: true, stopNo: 45, stopName: "another stop name", schedules: nil)
                    
                    expect(viewModel == viewModelEqual).to(beTruthy())
                }
            }
            
            context ("without same identifiers") {
                it ("should be equal") {
                    var viewModelNotEqual = StopViewModel(identifier: "another identifier", routesNo: ["76"], stopDescription: "a description",  isUpStop: true, stopNo: 45, stopName: "a stop name", schedules: nil)
                    
                    expect(viewModel == viewModelNotEqual).to(beFalsy())
                }
            }
        }
    }
}
