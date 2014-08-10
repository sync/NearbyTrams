//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Cocoa
import NearbyTramsKit
import NearbyTramsStorageKit
import CoreData

class StopsViewController: NSViewController , NSTableViewDelegate, NSTableViewDataSource,StopsViewControllerModelDelegate, RouteSelectionManagerDelegate
{
    struct TableViewConstants {
        struct ViewIdentifiers {
            static let StopViewIdentifier = "StopViewIdentifier"
        }
    }
    
    @IBOutlet weak var tableView: NSTableView?
    let stopsViewControllerModel: StopsViewControllerModel
    
    let managedObjectContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        moc.persistentStoreCoordinator = CoreDataStackManager.sharedInstance.persistentStoreCoordinator
        return moc
        }()
    
    required init(coder: NSCoder!)
    {
        let stopsViewModel = StopsViewModel(managedObjectContext: managedObjectContext)
        self.stopsViewControllerModel = StopsViewControllerModel(viewModel: stopsViewModel, managedObjectContext: managedObjectContext)

        super.init(coder: coder)
        
        self.stopsViewControllerModel.delegate = self
    }
    
    // MARK: NSTableViewDataSource
    func numberOfRowsInTableView(tableView: NSTableView!) -> Int
    {
        return self.stopsViewControllerModel.stopsCount
    }
    
    // MARK: NSTableViewDelegate
    func tableView(tableView: NSTableView, viewForTableColumn: NSTableColumn, row: Int) -> NSView
    {
        let stopModel = self.stopsViewControllerModel.stopAtIndex(row)
        
        var stopView = tableView.makeViewWithIdentifier(TableViewConstants.ViewIdentifiers.StopViewIdentifier, owner: nil) as NSTableCellView
        stopView.textField.stringValue = "\(stopModel.stopNo) - \(stopModel.stopName) - \(stopModel.isUpStop)"
        
        return stopView
    }
    
    // MARK: StopsViewControllerModelDelegate
    func stopsViewControllerModelDidUpdateStops(model: StopsViewControllerModel)
    {
        self.tableView?.reloadData()
    }
    
    // MARK: RouteSelectionManagerDelegate
    func routeSelectionManagerDidChangeSelectedRoute(selectionManager: RouteSelectionManager, route: Route?)
    {
        self.stopsViewControllerModel.route = route
    }
}

