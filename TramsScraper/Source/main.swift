//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

struct Route
{
    let routeNo: Int?
    let internalRouteNo: Int?
    let alphaNumericRouteNo: String?
    let destination: String?
    let isUpDestination: Bool?
    let hasLowFloor: Bool?
    
    init(json: NSDictionary)
    {
        routeNo = json["RouteNo"] as? Int
        internalRouteNo = json["InternalRouteNo"] as? Int
        alphaNumericRouteNo = json["AlphaNumericRouteNo"] as? String
        destination = json["Destination"] as? String
        isUpDestination = json["IsUpDestination"] as? Bool
        hasLowFloor = json["HasLowFloor"] as? Bool
    }
}

func parseJSON(inputData: NSData) -> NSDictionary
{
    var dictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
    
    return dictionary
}

func getAllRoutesWithCompletion(completionHandler: ((Route[]?, NSError?) -> Void)!) -> NSURLSessionDataTask!
{
    // thanks to: http://wongm.com/2014/03/tramtracker-api-dumphone-access/
    let url = NSURL(string: "http://www.tramtracker.com/Controllers/GetAllRoutes.ashx")
    let session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
    let task = session.dataTaskWithURL(url, completionHandler:{
        data, response, error -> Void in
        
        if (error)
        {
            completionHandler(nil, error)
        }
        else if let routesArray = parseJSON(data)["ResponseObject"] as? NSDictionary[]
        {
            var routes = routesArray.map({
                (routeDictionary: NSDictionary) -> Route in
                return Route(json: routeDictionary)
                })
            
            completionHandler(routes, nil)
        }
        })
    task.resume()
    
    return task;
}

var completed: Bool = false
let allRoutesTask = getAllRoutesWithCompletion{
    routes, error -> Void in
    
    if (error)
    {
        println("there was an error dowloading all routes: \(error!.localizedDescription)")
    }
    else if (routes)
    {
        println("got all routes")
    }
    
    completed = true
}

while (!completed)
{
    // do nothing
}
