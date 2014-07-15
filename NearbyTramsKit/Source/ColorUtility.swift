//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

struct ColorUtility
{
    static func generateRandomColor() -> CGColorRef
    {
        return CGColorCreateGenericRGB(CGFloat(arc4random_uniform(255)) / 255.0, CGFloat(arc4random_uniform(255)) / 255.0, CGFloat(arc4random_uniform(255)) / 255.0, 1.0)
    }
}
