//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

public class RouteViewModel: Equatable
{
    public let identifier: String
    public var routeNo: String
    public var routeDescription: String
    public var downDestination: String
    public var upDestination: String
    public let color: CGColorRef
    
    public init (identifier: String, routeNo: String, routeDescription: String, downDestination: String, upDestination: String, color: CGColorRef = ColorUtility.generateRandomColor())
    {
        self.identifier = identifier
        self.routeNo = routeNo
        self.routeDescription = routeDescription
        self.downDestination = downDestination
        self.upDestination = upDestination
        self.color = color
    }
    
    public func updateWithRouteNo(routeNo: String, routeDescription: String, downDestination: String, upDestination: String)
    {
        self.routeNo = routeNo
        self.routeDescription = routeDescription
        self.downDestination = downDestination
        self.upDestination = upDestination
        self.routeDescription = routeDescription
    }
}

public func ==(lhs: RouteViewModel, rhs: RouteViewModel) -> Bool
{
    return lhs.identifier == rhs.identifier
}
