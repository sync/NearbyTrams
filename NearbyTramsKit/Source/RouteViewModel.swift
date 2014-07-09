//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation
import CoreFoundation

class RouteViewModel
{
    let identifier: String
    let routeNo: Int
    let destination: String
    let isUpDestination: Bool
    let color: CGColorRef
    
    init (identifier: String, routeNo: Int, destination: String, isUpDestination: Bool, color: CGColorRef = CGColorCreateGenericRGB(CGFloat(arc4random_uniform(255)) / 255.0, CGFloat(arc4random_uniform(255)) / 255.0, CGFloat(arc4random_uniform(255)) / 255.0, 1.0))
    {
        self.identifier = identifier
        self.routeNo = routeNo
        self.destination = destination
        self.isUpDestination = isUpDestination
        self.color = color
    }
}
