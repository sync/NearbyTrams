//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

class StopViewModel
{
    let identifier: String
    var routeNo: Int
    var destination: String
    var isUpDestination: Bool
    var stopNo: Int
    var stopName: String
    var schedules: NSDate[]?
    
    init (identifier: String, routeNo: Int, destination: String, isUpDestination: Bool, stopNo: Int, stopName: String, schedules: NSDate[]?)
    {
        self.identifier = identifier
        self.routeNo = routeNo
        self.destination = destination
        self.isUpDestination = isUpDestination
        self.stopNo = stopNo
        self.stopName = stopName
        self.schedules = schedules
    }
    
    func updateWithRouteNo(routeNo: Int, destination: String, isUpDestination: Bool, stopNo: Int, stopName: String, schedules: NSDate[]?)
    {
        self.routeNo = routeNo
        self.destination = destination
        self.isUpDestination = isUpDestination
        self.stopNo = stopNo
        self.stopName = stopName
        self.schedules = schedules
    }
}

