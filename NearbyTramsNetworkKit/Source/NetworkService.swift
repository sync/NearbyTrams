//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

class NetworkService
{
    let baseURL: NSURL
    let aid: NSString
    let token: NSString
    let configuration: NSURLSessionConfiguration
    let session: NSURLSession
    
    // FIXME: token need to be generated on the fly, per user
    init(baseURL: NSURL = NSURL(string: "http://ws3.tramtracker.com.au"), aid: NSString = "TTIOSJSON", token: NSString = "b79c738a-281c-4d81-9111-36591a5237bf", configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration())
    {
        self.baseURL = baseURL
        self.aid = aid
        self.token = token
        self.configuration = configuration
        self.session = NSURLSession(configuration: configuration)
    }
    
    func tokenisedURLWithString(string: String, appendCid: Bool = false) -> NSURL
    {
        let tokenisedString = "\(string)?aid=\(self.aid)&tkn=\(self.token)" + (appendCid ? "&cid=2" : "")
        return NSURL(string: tokenisedString, relativeToURL:self.baseURL)
    }

    func getAllRoutesWithCompletionHandler(completionHandler: ((NSDictionary[]?, NSError?) -> Void)?) -> NSURLSessionDataTask
    {
        let url = tokenisedURLWithString("TramTracker/RestService/GetDestinationsForAllRoutes/")
        
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
        
        return task
    }

    func getStopsByRouteAndDirectionWithRouteNo(routeNo: Int, isUpStop: Bool, completionHandler: ((NSDictionary[]?, NSError?) -> Void)?) -> NSURLSessionDataTask
    {
        let url = tokenisedURLWithString("TramTracker/RestService/GetListOfStopsByRouteNoAndDirection/\(routeNo)/\(isUpStop)/")
        
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
        
        return task
    }

    func getStopInformationWithStopNo(stopNo: Int, completionHandler: ((NSDictionary?, NSError?) -> Void)?) -> NSURLSessionDataTask
    {
        let url = tokenisedURLWithString("TramTracker/RestService/GetStopInformation/\(stopNo)/")
        
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
        
        return task
    }
    
    func getNextPredictionsWithStopNo(stopNo: Int, routeNo: Int = 0, completionHandler: ((NSDictionary[]?, NSError?) -> Void)?) -> NSURLSessionDataTask
    {
        let url = tokenisedURLWithString("TramTracker/RestService/GetNextPredictedRoutesCollection/\(stopNo)/\(routeNo)/false/", appendCid: true)
        
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
                    handler(dictionary["responseObject"] as? NSDictionary[], nil)
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
        
        return task
    }
}
