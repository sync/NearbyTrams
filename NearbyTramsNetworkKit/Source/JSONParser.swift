//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

class JSONParser
{
    class func parseJSON(inputData: NSData) -> (object: AnyObject?, error:NSError?)
    {
        var error: NSError?
        var object : AnyObject? = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error)
        
        return (object, error)
    }
}
