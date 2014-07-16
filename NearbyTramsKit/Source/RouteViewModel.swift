//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

class RouteViewModel
{
    let identifier: String
    var routeNo: Int
    var destination: String
    var isUpDestination: Bool
    let color: CGColorRef
    
    init (identifier: String, routeNo: Int, destination: String, isUpDestination: Bool, color: CGColorRef = ColorUtility.generateRandomColor())
    {
        self.identifier = identifier
        self.routeNo = routeNo
        self.destination = destination
        self.isUpDestination = isUpDestination
        self.color = color
    }
    
    func updateWithRouteNo(routeNo: Int, destination: String, isUpDestination: Bool)
    {
        self.routeNo = routeNo
        self.isUpDestination = isUpDestination
        self.destination = destination
    }
}
