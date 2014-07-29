//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

public enum ColorUtility
{
    public static func generateRandomColor() -> CGColorRef
    {
        let red = CGFloat(Int(arc4random_uniform(255))) / 255.0
        let green = CGFloat(Int(arc4random_uniform(255))) / 255.0
        let blue = CGFloat(Int(arc4random_uniform(255))) / 255.0
        
        return CGColorCreateGenericRGB(red, green, blue, 1.0)
    }
}
