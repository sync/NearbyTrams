//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Cocoa
import NearbyTramsKit
import NearbyTramsStorageKit
import CoreData

protocol RouteSelectionManagerDelegate
{
    func routeSelectionManagerDidChangeSelectedRoute(selectionManager: RouteSelectionManager, route: Route?)
}

class RouteSelectionManager
{
    var delegate: RouteSelectionManagerDelegate?
    
    var selectedRoute: Route?{
    didSet {
        self.delegate?.routeSelectionManagerDidChangeSelectedRoute(self, route: selectedRoute)
    }
    }
    
    init ()
    {
        
    }
}
