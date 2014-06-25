//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

class NetworkService
{
    let baseURL: NSURL
    let configuration: NSURLSessionConfiguration
    
    init(baseURL: NSURL = NSURL(string: "http://www.tramtracker.com"), configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.ephemeralSessionConfiguration())
    {
        self.baseURL = baseURL
        self.configuration = configuration
    }

    func getAllRoutesWithCompletionHandler(completionHandler: ((NSDictionary[]?, NSError?) -> Void)?) -> NSURLSessionDataTask
    {
        // thanks to: http://wongm.com/2014/03/tramtracker-api-dumphone-access/
        let url = NSURL(string: "Controllers/GetAllRoutes.ashx", relativeToURL:baseURL)
        
        let session = NSURLSession(configuration: configuration)
        let task = session.dataTaskWithURL(url, completionHandler:{
            data, response, error -> Void in
            
            if (error)
            {
                if let handler = completionHandler
                {
                    handler(nil, error)
                }
                return
            }
            
            let (object : AnyObject?, error) = JSONParser.parseJSON(data)
            if let dictionary = object as? NSDictionary
            {
                if let handler = completionHandler
                {
                    handler(dictionary["ResponseObject"] as? NSDictionary[], nil)
                }
            }
            else
            {
                if let handler = completionHandler
                {
                    handler(nil, error)
                }
            }
            })
        task.resume()
        
        return task;
    }

    func getStopsByRouteAndDirectionWithStopNo(stopNo: NSString, completionHandler: ((NSDictionary[]?, NSError?) -> Void)?) -> NSURLSessionDataTask
    {
        // thanks to: http://wongm.com/2014/03/tramtracker-api-dumphone-access/
        // not sure what &u=true is at the moment
        let url = NSURL(string: "/Controllers/GetStopsByRouteAndDirection.ashx?s=\(stopNo)&u=true", relativeToURL: baseURL)
        
        let session = NSURLSession(configuration: configuration)
        let task = session.dataTaskWithURL(url, completionHandler:{
            data, response, error -> Void in
            
            if (error)
            {
                if let handler = completionHandler
                {
                    handler(nil, error)
                }
                return
            }
            
            let (object : AnyObject?, error) = JSONParser.parseJSON(data)
            if let dictionary = object as? NSDictionary
            {
                if let handler = completionHandler
                {
                    handler(dictionary["ResponseObject"] as? NSDictionary[], nil)
                }
            }
            else
            {
                if let handler = completionHandler
                {
                    handler(nil, error)
                }
            }
            })
        task.resume()
        
        return task;
    }
    
    func getStopInformationWithStopNo(stopNo: NSString, completionHandler: ((NSDictionary?, NSError?) -> Void)?) -> NSURLSessionDataTask
    {
        // thanks to: http://wongm.com/2014/03/tramtracker-api-dumphone-access/
        let url = NSURL(string: "/Controllers/GetStopInformation.ashx?stopNo=\(stopNo)", relativeToURL: baseURL)
        
        let session = NSURLSession(configuration: configuration)
        let task = session.dataTaskWithURL(url, completionHandler:{
            data, response, error -> Void in
            
            if (error)
            {
                if let handler = completionHandler
                {
                    handler(nil, error)
                }
                return
            }
            
            let (object : AnyObject?, error) = JSONParser.parseJSON(data)
            if let dictionary = object as? NSDictionary
            {
                if let handler = completionHandler
                {
                    handler(dictionary["ResponseObject"] as? NSDictionary, nil)
                }
            }
            else
            {
                if let handler = completionHandler
                {
                    handler(nil, error)
                }
            }
            })
        task.resume()
        
        return task;
    }
    
    func getNextPredictionsForStop(stopNo: NSString, timestamp: NSDate, completionHandler: ((NSDictionary[]?, NSError?) -> Void)?) -> NSURLSessionDataTask
    {
        // thanks to: http://wongm.com/2014/03/tramtracker-api-dumphone-access/
        // not sure about ts format yet, unix time ??
        let url = NSURL(string: "/Controllers/GetNextPredictionsForStop.ashx?s=\(stopNo)&routeNo=0&isLowFloor=false&ts=\(timestamp.timeIntervalSince1970 * 1000)", relativeToURL: baseURL)
        
        let session = NSURLSession(configuration: configuration)
        let task = session.dataTaskWithURL(url, completionHandler:{
            data, response, error -> Void in
            
            if (error)
            {
                if let handler = completionHandler
                {
                    handler(nil, error)
                }
                return
            }
            
            let (object : AnyObject?, error) = JSONParser.parseJSON(data)
            if let dictionary = object as? NSDictionary
            {
                if let handler = completionHandler
                {
                    handler(dictionary["ResponseObject"] as? NSDictionary[], nil)
                }
            }
            else
            {
                if let handler = completionHandler
                {
                    handler(nil, error)
                }
            }
            })
        task.resume()
        
        return task;
    }
}
