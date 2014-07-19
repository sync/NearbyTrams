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
    
    @IBOutlet var tableView: NSTableView
    let stopsViewControllerModel: StopsViewControllerModel
    
    let managedObjectContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        moc.persistentStoreCoordinator = CoreDataStackManager.sharedInstance.persistentStoreCoordinator
        return moc
        }()
    
    init(coder: NSCoder!)
    {
        let stopsViewModel = StopsViewModel(managedObjectContext: managedObjectContext)
        let provider = SchedulesProvider(managedObjectContext: managedObjectContext)
        self.stopsViewControllerModel = StopsViewControllerModel(viewModel: stopsViewModel, provider: provider, managedObjectContext: managedObjectContext)

        super.init(coder: coder)
        
        self.stopsViewControllerModel.delegate = self
    }
    
    // NSTableViewDataSource
    func numberOfRowsInTableView(tableView: NSTableView!) -> Int
    {
        return self.stopsViewControllerModel.stopsCount
    }
    
    // NSTableViewDelegate
    func tableView(tableView: NSTableView, viewForTableColumn: NSTableColumn, row: Int) -> NSView
    {
        let stopModel = self.stopsViewControllerModel.stopAtIndex(row)
        
        var stopView = tableView.makeViewWithIdentifier(TableViewConstants.ViewIdentifiers.StopViewIdentifier, owner: nil) as NSTableCellView
        stopView.textField.stringValue = "\(stopModel.stopNo) - \(stopModel.stopName) - \(stopModel.isUpStop)"
        
        return stopView
    }
    
    // StopsViewControllerModelDelegate
    func stopsViewControllerModelDidUpdateStops(model: StopsViewControllerModel)
    {
        self.tableView.reloadData()
    }
    
    // RouteSelectionManagerDelegate
    func routeSelectionManagerDidChangeSelectedRoute(selectionManager: RouteSelectionManager, route: Route?)
    {
        self.stopsViewControllerModel.route = route
    }
}

