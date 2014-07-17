//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

class RouteViewModel
{
    let identifier: String
    var routeNo: Int
    var name: String
    var isUpStop: Bool
    let color: CGColorRef
    
    init (identifier: String, routeNo: Int, name: String, isUpStop: Bool, color: CGColorRef = ColorUtility.generateRandomColor())
    {
        self.identifier = identifier
        self.routeNo = routeNo
        self.name = name
        self.isUpStop = isUpStop
        self.color = color
    }
    
    func updateWithRouteNo(routeNo: Int, name: String, isUpStop: Bool)
    {
        self.routeNo = routeNo
        self.isUpStop = isUpStop
        self.name = name
    }
}
