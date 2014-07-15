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
                    viewModel = RouteViewModel(identifier: "an identifier", routeNo: 76, destination: "a destination",  isUpDestination: true, color: color)
                }
                
                it ("should remember it") {
                    let colorsAreEqual = CGColorEqualToColor(color, viewModel.color)
                    expect(colorsAreEqual).to.beTrue()
                }
            }
        }
    }
}
