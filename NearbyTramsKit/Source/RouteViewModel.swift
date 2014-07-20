//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

class RouteViewModel: Equatable
{
    let identifier: String
    var routeNo: String
    var routeDescription: String
    var downDestination: String
    var upDestination: String
    let color: CGColorRef
    
    init (identifier: String, routeNo: String, routeDescription: String, downDestination: String, upDestination: String, color: CGColorRef = ColorUtility.generateRandomColor())
    {
        self.identifier = identifier
        self.routeNo = routeNo
        self.routeDescription = routeDescription
        self.downDestination = downDestination
        self.upDestination = upDestination
        self.color = color
    }
    
    func updateWithRouteNo(routeNo: String, routeDescription: String, downDestination: String, upDestination: String)
    {
        self.routeNo = routeNo
        self.routeDescription = routeDescription
        self.downDestination = downDestination
        self.upDestination = upDestination
        self.routeDescription = routeDescription
    }
}

@infix func ==(lhs: RouteViewModel, rhs: RouteViewModel) -> Bool
{
    return lhs.identifier == rhs.identifier
}
