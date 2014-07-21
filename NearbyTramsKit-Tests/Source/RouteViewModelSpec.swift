//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsKit

class RouteViewModelSpec: QuickSpec {
    override func spec() {
        
        var viewModel: RouteViewModel!
        
        describe("init") {
            context("when given a color") {
                var color: CGColorRef!
                
                beforeEach {
                    color = CGColorCreateGenericGray(0.5, 1.0)
                    viewModel = RouteViewModel(identifier: "an identifier", routeNo: "76", routeDescription: "a descption",  downDestination: "a down destination", upDestination: "an up destination", color: color)
                }
                
                it ("should remember it") {
                    let colorsAreEqual = CGColorEqualToColor(color, viewModel.color)
                    expect(colorsAreEqual).to.beTrue()
                }
            }
        }
        
        describe("equatable") {
            beforeEach {
                viewModel = RouteViewModel(identifier: "an identifier", routeNo: "76", routeDescription: "a descption",  downDestination: "a down destination", upDestination: "an up destination")
            }
            
            context ("with the same identifiers") {
                it ("should be equal") {
                    var viewModelEqual = RouteViewModel(identifier: "an identifier", routeNo: "76", routeDescription: "a descption",  downDestination: "a down destination", upDestination: "another up destination")
                    
                    expect(viewModel == viewModelEqual).to.beTrue()
                }
            }
            
            context ("without same identifiers") {
                it ("should be equal") {
                    var viewModelNotEqual = RouteViewModel(identifier: "another identifier", routeNo: "76", routeDescription: "a descption",  downDestination: "a down destination", upDestination: "an up destination")
                    
                    expect(viewModel == viewModelNotEqual).to.beFalse()
                }
            }
        }
    }
}
