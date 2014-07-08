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
                    viewModel = RouteViewModel(identifier: "an identifier", routeNo: 76,  isUpDestination: true, color: color)
                }
                
                it ("should remember it") {
                    // FIXME: hack for test to compile
                    let modelColors: NSArray = [viewModel.color]
                    let colors: NSArray = [color!]
                    expect(modelColors).to.equal(colors)
                }
            }
        }
    }
}
