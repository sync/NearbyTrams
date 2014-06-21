//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Appkit
import Quick
import Nimble

class Dolphin
{
    func isFriendly() -> Bool
    {
        return true
    }
    
    func isSmart() -> Bool
    {
        return true
    }
}

class DolphinSpec: QuickSpec {
    override func spec() {
        it("is friendly") {
            expect(Dolphin().isFriendly()).to.beTrue()
        }
        
        it("is smart") {
            expect(Dolphin().isSmart()).to.beTrue()
        }
    }
}
