//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

class StopViewModel: Equatable
{
    let identifier: String
    var routeNo: String
    var routeDescription: String
    var isUpStop: Bool
    var stopNo: Int
    var stopName: String
    var schedules: NSDate[]?
    
    init (identifier: String, routeNo: String, routeDescription: String, isUpStop: Bool, stopNo: Int, stopName: String, schedules: NSDate[]?)
    {
        self.identifier = identifier
        self.routeNo = routeNo
        self.routeDescription = routeDescription
        self.isUpStop = isUpStop
        self.stopNo = stopNo
        self.stopName = stopName
        self.schedules = schedules
    }
    
    func updateWithRouteNo(routeNo: String, routeDescription: String, isUpStop: Bool, stopNo: Int, stopName: String, schedules: NSDate[]?)
    {
        self.routeNo = routeNo
        self.routeDescription = routeDescription
        self.isUpStop = isUpStop
        self.stopNo = stopNo
        self.stopName = stopName
        self.schedules = schedules
    }
}

@infix func ==(lhs: StopViewModel, rhs: StopViewModel) -> Bool
{
    return lhs.identifier == rhs.identifier
}
