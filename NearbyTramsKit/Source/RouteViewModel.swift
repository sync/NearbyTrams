//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

class RouteViewModel
{
    let identifier: String
    let routeNo: Int
    let destination: String
    let isUpDestination: Bool
    let color: CGColorRef
    
    init (identifier: String, routeNo: Int, destination: String, isUpDestination: Bool, color: CGColorRef = ColorUtility.generateRandomColor())
    {
        self.identifier = identifier
        self.routeNo = routeNo
        self.destination = destination
        self.isUpDestination = isUpDestination
        self.color = color
    }
}
