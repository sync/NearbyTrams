//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

class NetworkService
{
    let baseURL: NSURL
    let configuration: NSURLSessionConfiguration
    
    init(baseURL: NSURL, configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.ephemeralSessionConfiguration())
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
    
    func getStopInformationWithStopId(stopId: NSString, completionHandler: ((NSDictionary?, NSError?) -> Void)?) -> NSURLSessionDataTask
    {
        // thanks to: http://wongm.com/2014/03/tramtracker-api-dumphone-access/
        let url = NSURL(string: "/Controllers/GetStopInformation.ashx?s=\(stopId)", relativeToURL: baseURL)
        
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
}
