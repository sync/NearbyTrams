//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

public class StopViewModel: Equatable
{
    public let identifier: String
    public var routesNo: [String]
    public var stopDescription: String
    public var isUpStop: Bool
    public var stopNo: Int
    public var stopName: String
    public var schedules: [NSDate]?
    
    public init (identifier: String, routesNo: [String], stopDescription: String, isUpStop: Bool, stopNo: Int, stopName: String, schedules: [NSDate]?)
    {
        self.identifier = identifier
        self.routesNo = routesNo
        self.stopDescription = stopDescription
        self.isUpStop = isUpStop
        self.stopNo = stopNo
        self.stopName = stopName
        self.schedules = schedules
    }
    
    public func updateWithRoutesNo(routesNo: [String], stopDescription: String, isUpStop: Bool, stopNo: Int, stopName: String, schedules: [NSDate]?)
    {
        self.routesNo = routesNo
        self.stopDescription = stopDescription
        self.isUpStop = isUpStop
        self.stopNo = stopNo
        self.stopName = stopName
        self.schedules = schedules
    }
}

public func ==(lhs: StopViewModel, rhs: StopViewModel) -> Bool
{
    return lhs.identifier == rhs.identifier
}
