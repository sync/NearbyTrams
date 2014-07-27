//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsNetworkKit

class TestClassUtility: NSObject
{
    
}

class ClassUtilitySpec: QuickSpec {
    override func spec() {
        describe("classFromType") {
            context("given a NSObject subclass") {
                it("should return a objective-c meta class") {
                    let clazz: AnyObject = ClassUtility.classFromType(TestClassUtility.self)
                    
                    expect(clazz is NSObject).to(beTruthy())
                }
            }
        }
    }
}

