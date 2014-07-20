//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Cocoa
import NearbyTramsKit
import NearbyTramsStorageKit
import CoreData

class RoutesViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, RoutesViewControllerModelDelegate
{
    struct TableViewConstants {
        struct ViewIdentifiers {
            static let RouteViewIdentifier = "RouteViewIdentifier"
        }
    }
    
    @IBOutlet var tableView: NSTableView
    
    let managedObjectContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        moc.persistentStoreCoordinator = CoreDataStackManager.sharedInstance.persistentStoreCoordinator
        return moc
        }()
    
    let routesViewControllerModel: RoutesViewControllerModel
    
    init(coder: NSCoder!)
    {
        let routesViewModel = RoutesViewModel(managedObjectContext: managedObjectContext)
        self.routesViewControllerModel = RoutesViewControllerModel(viewModel: routesViewModel)
        
        super.init(coder: coder)
        
        self.routesViewControllerModel.delegate = self
    }
    
    // NSTableViewDataSource
    func numberOfRowsInTableView(tableView: NSTableView!) -> Int
    {
        return self.routesViewControllerModel.routesCount
    }
    
    // NSTableViewDelegate
    func tableView(tableView: NSTableView, viewForTableColumn: NSTableColumn, row: Int) -> NSView
    {
        let routeModel = self.routesViewControllerModel.routeAtIndex(row)
        
        var routeView = tableView.makeViewWithIdentifier(TableViewConstants.ViewIdentifiers.RouteViewIdentifier, owner: nil) as NSTableCellView
        routeView.textField.stringValue = "\(routeModel.routeNo) - \(routeModel.routeDescription)"
        
        return routeView
    }
    
    // RoutesViewControllerModelDelegate
    func routesViewControllerModelDidUpdateRoutes(model: RoutesViewControllerModel)
    {
        self.tableView.reloadData()
    }
}
