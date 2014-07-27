//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

public class JSONParser
{
    public class func parseJSON(inputData: NSData) -> (object: AnyObject?, error:NSError?)
    {
        var error: NSError?
        var object : AnyObject? = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error)
        
        return (object, error)
    }
}
