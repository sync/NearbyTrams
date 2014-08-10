//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Cocoa

class WindowViewController: NSWindowController {

    required init(coder: NSCoder!)
    {
        super.init(coder: coder)
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.window.titleVisibility = .Hidden
    }
}
