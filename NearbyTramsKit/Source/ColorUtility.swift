//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

public enum ColorUtility
{
    public static func generateRandomColor() -> CGColorRef
    {
        return CGColorCreateGenericRGB(0.0, 0.0, 0.0, 1.0)
    }
}
