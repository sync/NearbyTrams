// Playground - noun: a place where people can play

import XCPlayground
import Cocoa

struct StopInformation
{
    let cityDirection: String?
    let stopDescription: String?
    let destination: String?
    let distanceToLocation: Double?
    let flagStopNo: String?
    let latitude: Double?
    let longitude: Double?
    let routeNo: Int?
    let stopID : String?
    let stopName : String?
    let stopNo: Int?
    let suburb: String?
    
    
    init(json: NSDictionary)
    {
        cityDirection = json["CityDirection"] as? String
        stopDescription = json["Description"] as? String
        destination = json["Destination"] as? String
        distanceToLocation = json["DistanceToLocation"] as? Double
        flagStopNo = json["FlagStopNo"] as? String
        latitude = json["Latitude"] as? Double
        longitude = json["Longitude"] as? Double
        routeNo = json["RouteNo"]  as? Int
        stopID = json["StopID"] as? String
        stopName = json["StopName"] as? String
        stopNo = json["StopNo"]  as? Int
        suburb = json["Suburb"] as? String
    }
}

func parseJSON(inputData: NSData) -> NSDictionary
{
    var dictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
    
    return dictionary
}

func getStopInformationWithStopId(stopId: NSString, completionHandler: ((StopInformation?, NSError?) -> Void)!) -> NSURLSessionDataTask!
{
    // thanks to: http://wongm.com/2014/03/tramtracker-api-dumphone-access/
    let url = NSURL(string: "http://tramtracker.com/Controllers/GetStopInformation.ashx?s=\(stopId)")
    let session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
    let task = session.dataTaskWithURL(url, completionHandler:{
        data, response, error -> Void in
        
        if (error)
        {
            completionHandler(nil, error)
        }
        else if let dict = parseJSON(data)["ResponseObject"] as? NSDictionary
        {
            let stop = StopInformation(json: dict)
            completionHandler(stop, nil)
        }
    })
    task.resume()
    
    return task;
}

let stopId = "1234"
let stopInfoTask = getStopInformationWithStopId(stopId, {
    stop, error -> Void in
    
    if (error)
    {
        println("there was an error dowloading stop information for id: \(stopId) error: \(error!.localizedDescription)")
    }
    else if (stop)
    {
        println("got stop information for id: \(stopId)")
    }
})

XCPSetExecutionShouldContinueIndefinitely(continueIndefinitely: true)
