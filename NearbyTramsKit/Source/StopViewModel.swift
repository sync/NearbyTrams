//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

class StopViewModel
{
    let identifier: String
    let routeNo: Int
    let destination: String
    let isUpDestination: Bool
    let stopNo: Int
    let stopName: String
    
    init (identifier: String, routeNo: Int, destination: String, isUpDestination: Bool, stopNo: Int, stopName: String)
    {
        self.identifier = identifier
        self.routeNo = routeNo
        self.destination = destination
        self.isUpDestination = isUpDestination
        self.stopNo = stopNo
        self.stopName = stopName
    }
}

