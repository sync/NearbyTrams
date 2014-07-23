//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

public class StopViewModel: Equatable
{
    public let identifier: String
    public var routeNo: String
    public var routeDescription: String
    public var isUpStop: Bool
    public var stopNo: Int
    public var stopName: String
    public var schedules: [NSDate]?
    
    public init (identifier: String, routeNo: String, routeDescription: String, isUpStop: Bool, stopNo: Int, stopName: String, schedules: [NSDate]?)
    {
        self.identifier = identifier
        self.routeNo = routeNo
        self.routeDescription = routeDescription
        self.isUpStop = isUpStop
        self.stopNo = stopNo
        self.stopName = stopName
        self.schedules = schedules
    }
    
    public func updateWithRouteNo(routeNo: String, routeDescription: String, isUpStop: Bool, stopNo: Int, stopName: String, schedules: [NSDate]?)
    {
        self.routeNo = routeNo
        self.routeDescription = routeDescription
        self.isUpStop = isUpStop
        self.stopNo = stopNo
        self.stopName = stopName
        self.schedules = schedules
    }
}

@infix public func ==(lhs: StopViewModel, rhs: StopViewModel) -> Bool
{
    return lhs.identifier == rhs.identifier
}
