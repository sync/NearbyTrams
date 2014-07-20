//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

class NetworkService
{
    struct Error {
        struct Domain {
            static let name = "au.com.dlbechoc.network"
        }
        
        enum Code: Int {
            case Unknown = 0, API
        }
    }
    
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
        let url = tokenisedURLWithString("TramTracker/RestService/GetRouteSummaries/")
        
        let task = session.dataTaskWithURL(url, completionHandler:{
            data, response, error -> Void in
            
            if let requestError = error
            {
                if let handler = completionHandler
                {
                    handler(nil, error)
                }
                return
            }
            
            let (object : AnyObject?, jsonParserError) = JSONParser.parseJSON(data)
            
            if let parserError = jsonParserError
            {
                if let handler = completionHandler
                {
                    handler(nil, parserError)
                }
                return
            }
            
            if let dictionary = object as? NSDictionary
            {
                let hasAPIError = dictionary["hasError"] as? Bool
                if hasAPIError && hasAPIError!
                {
                    if let handler = completionHandler
                    {
                        var userInfo: Dictionary<String, AnyObject> = [ : ]
                        if let errorMessage = dictionary["errorMessage"] as? String
                        {
                            userInfo[NSLocalizedDescriptionKey] = errorMessage
                        }
                        
                        let apiError = NSError(domain: Error.Domain.name, code: Error.Code.API.toRaw(), userInfo: userInfo)
                        handler(nil, apiError)
                    }
                    return
                }
                else
                {
                    if let handler = completionHandler
                    {
                        handler(dictionary["responseObject"] as? NSDictionary[], nil)
                    }
                }
            }
            else
            {
                if let handler = completionHandler
                {
                    var userInfo: Dictionary<String, AnyObject> = [ NSLocalizedDescriptionKey: "Unable to parse server response" ]
                    let emptyContentError =  NSError(domain: Error.Domain.name, code: Error.Code.API.toRaw(), userInfo: userInfo)
                    handler(nil, emptyContentError)
                }
                return
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
            
            if let requestError = error
            {
                if let handler = completionHandler
                {
                    handler(nil, error)
                }
                return
            }
            
            let (object : AnyObject?, jsonParserError) = JSONParser.parseJSON(data)
            
            if let parserError = jsonParserError
            {
                if let handler = completionHandler
                {
                    handler(nil, parserError)
                }
                return
            }
            
            if let dictionary = object as? NSDictionary
            {
                let hasAPIError = dictionary["hasError"] as? Bool
                if hasAPIError && hasAPIError!
                {
                    if let handler = completionHandler
                    {
                        var userInfo: Dictionary<String, AnyObject> = [ : ]
                        if let errorMessage = dictionary["errorMessage"] as? String
                        {
                            userInfo[NSLocalizedDescriptionKey] = errorMessage
                        }
                        
                        let apiError = NSError(domain: Error.Domain.name, code: Error.Code.API.toRaw(), userInfo: userInfo)
                        handler(nil, apiError)
                    }
                    return
                }
                else
                {
                    if let handler = completionHandler
                    {
                        handler(dictionary["responseObject"] as? NSDictionary[], nil)
                    }
                }
            }
            else
            {
                if let handler = completionHandler
                {
                    var userInfo: Dictionary<String, AnyObject> = [ NSLocalizedDescriptionKey: "Unable to parse server response" ]
                    let emptyContentError =  NSError(domain: Error.Domain.name, code: Error.Code.API.toRaw(), userInfo: userInfo)
                    handler(nil, emptyContentError)
                }
                return
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
            
            if let requestError = error
            {
                if let handler = completionHandler
                {
                    handler(nil, error)
                }
                return
            }
            
            let (object : AnyObject?, jsonParserError) = JSONParser.parseJSON(data)
            
            if let parserError = jsonParserError
            {
                if let handler = completionHandler
                {
                    handler(nil, parserError)
                }
                return
            }
            
            if let dictionary = object as? NSDictionary
            {
                let hasAPIError = dictionary["hasError"] as? Bool
                if hasAPIError && hasAPIError!
                {
                    if let handler = completionHandler
                    {
                        var userInfo: Dictionary<String, AnyObject> = [ : ]
                        if let errorMessage = dictionary["errorMessage"] as? String
                        {
                            userInfo[NSLocalizedDescriptionKey] = errorMessage
                        }
                        
                        let apiError = NSError(domain: Error.Domain.name, code: Error.Code.API.toRaw(), userInfo: userInfo)
                        handler(nil, apiError)
                    }
                    return
                }
                else
                {
                    if let handler = completionHandler
                    {
                        handler(dictionary["responseObject"] as? NSDictionary, nil)
                    }
                }
            }
            else
            {
                if let handler = completionHandler
                {
                    var userInfo: Dictionary<String, AnyObject> = [ NSLocalizedDescriptionKey: "Unable to parse server response" ]
                    let emptyContentError =  NSError(domain: Error.Domain.name, code: Error.Code.API.toRaw(), userInfo: userInfo)
                    handler(nil, emptyContentError)
                }
                return
            }
            })
        task.resume()
        
        return task
    }
    
    func getNextPredictionsWithStopNo(stopNo: Int, routeNo: String = "0", completionHandler: ((NSDictionary[]?, NSError?) -> Void)?) -> NSURLSessionDataTask
    {
        let url = tokenisedURLWithString("TramTracker/RestService/GetNextPredictedRoutesCollection/\(stopNo)/\(routeNo)/false/", appendCid: true)
        
        let task = session.dataTaskWithURL(url, completionHandler:{
            data, response, error -> Void in
            
            if let requestError = error
            {
                if let handler = completionHandler
                {
                    handler(nil, error)
                }
                return
            }
            
            let (object : AnyObject?, jsonParserError) = JSONParser.parseJSON(data)
            
            if let parserError = jsonParserError
            {
                if let handler = completionHandler
                {
                    handler(nil, parserError)
                }
                return
            }
            
            if let dictionary = object as? NSDictionary
            {
                let hasAPIError = dictionary["hasError"] as? Bool
                if hasAPIError && hasAPIError!
                {
                    if let handler = completionHandler
                    {
                        var userInfo: Dictionary<String, AnyObject> = [ : ]
                        if let errorMessage = dictionary["errorMessage"] as? String
                        {
                            userInfo[NSLocalizedDescriptionKey] = errorMessage
                        }
                        
                        let apiError = NSError(domain: Error.Domain.name, code: Error.Code.API.toRaw(), userInfo: userInfo)
                        handler(nil, apiError)
                    }
                    return
                }
                else
                {
                    if let handler = completionHandler
                    {
                        handler(dictionary["responseObject"] as? NSDictionary[], nil)
                    }
                }
            }
            else
            {
                if let handler = completionHandler
                {
                    var userInfo: Dictionary<String, AnyObject> = [ NSLocalizedDescriptionKey: "Unable to parse server response" ]
                    let emptyContentError =  NSError(domain: Error.Domain.name, code: Error.Code.API.toRaw(), userInfo: userInfo)
                    handler(nil, emptyContentError)
                }
                return
            }
            })
        task.resume()
        
        return task
    }
}
