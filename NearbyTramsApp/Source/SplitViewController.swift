//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Cocoa

class SplitViewController: NSSplitViewController
{
    let routeSelectionManager: RouteSelectionManager
    
    init(coder: NSCoder!)
    {
        routeSelectionManager = RouteSelectionManager()
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func addSplitViewItem(splitViewItem: NSSplitViewItem!)
    {
        super.addSplitViewItem(splitViewItem)
        
        if let viewController = splitViewItem.viewController as? RoutesViewController
        {
            viewController.routeSelectionManager = self.routeSelectionManager
        }
        
        if let viewController = splitViewItem.viewController as? StopsViewController
        {
            routeSelectionManager.delegate = viewController
        }
    }
}
