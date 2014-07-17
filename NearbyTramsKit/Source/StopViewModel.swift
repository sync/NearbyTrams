//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

class StopViewModel
{
    let identifier: String
    var routeNo: Int
    var name: String
    var isUpStop: Bool
    var stopNo: Int
    var stopName: String
    var schedules: NSDate[]?
    
    init (identifier: String, routeNo: Int, name: String, isUpStop: Bool, stopNo: Int, stopName: String, schedules: NSDate[]?)
    {
        self.identifier = identifier
        self.routeNo = routeNo
        self.name = name
        self.isUpStop = isUpStop
        self.stopNo = stopNo
        self.stopName = stopName
        self.schedules = schedules
    }
    
    func updateWithRouteNo(routeNo: Int, name: String, isUpStop: Bool, stopNo: Int, stopName: String, schedules: NSDate[]?)
    {
        self.routeNo = routeNo
        self.name = name
        self.isUpStop = isUpStop
        self.stopNo = stopNo
        self.stopName = stopName
        self.schedules = schedules
    }
}

