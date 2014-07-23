//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

public extension NSDate
{
    public class func fromDonet(string: NSString) -> NSDate!
    {
        let startPositionRange = string.rangeOfString("(")
        let endPositionRange = string.rangeOfString("+")
        if startPositionRange.location != NSNotFound && endPositionRange.location != NSNotFound
        {
            let startLocation = startPositionRange.location + startPositionRange.length
            let dateAsString = string.substringWithRange(NSRange(location: startLocation, length: endPositionRange.location - startLocation))
            let unixTimeInterval = (dateAsString as NSString).doubleValue / 1000
            return NSDate(timeIntervalSince1970: unixTimeInterval)
        }

        return nil
    }
    
    public func dotNetFormattedString() -> NSString
    {
        let timeSince1970 = self.timeIntervalSince1970
        let offset = Int(NSTimeInterval(NSTimeZone.defaultTimeZone().secondsFromGMT) / 3600)
        let nowMillis = 1000.0 * timeSince1970
        let dotNetDate = NSString(format: "/Date(%.0f%+03d00)/", nowMillis, offset)
        
        return NSString(format: "/Date(%.0f%+03d00)/", nowMillis, offset)
    }
}
