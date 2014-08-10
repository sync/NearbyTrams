//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

public struct MockWebServiceResponse
{
    public let body: AnyObject
    public let header: NSDictionary
    public let urlComponent: String?
    public let statusCode: Int
    public let error: NSError?
    
    public init (body: AnyObject, header: NSDictionary, urlComponentToMatch urlComponent: String? = nil, statusCode: Int = 200, error: NSError? = nil)
    {
        self.body = body
        self.header = header
        self.urlComponent = urlComponent
        self.statusCode = statusCode
        self.error = error
    }
}

var storage: [MockWebServiceResponse]?
public class MockWebServiceURLProtocol: NSURLProtocol
{
    public class func cannedResponses(responses: [MockWebServiceResponse]?)
    {
        storage = responses
    }
    
    public class func cannedResponse(response: MockWebServiceResponse?)
    {
        if let aResponse = response
        {
             storage = [aResponse]
        }
        else
        {
            storage = nil
        }
    }

    public class func responsesForURL(URL: NSURL) -> [MockWebServiceResponse]?
    {
        if let tmpResponses = storage
        {
            var responses = (tmpResponses as [MockWebServiceResponse]).filter{
                cannedResponse -> Bool in
                
                return (cannedResponse.urlComponent.hasValue) ? contains(URL.pathComponents as [String], cannedResponse.urlComponent!) : true
            }
            
            // give priority to responses that have a urlComponent
            responses.sort {
                (response1: MockWebServiceResponse, response2: MockWebServiceResponse) -> Bool in
                return response1.urlComponent > response1.urlComponent
            }
            
            return responses
        }
        
        return nil
    }
    
    override public class func canInitWithRequest(request: NSURLRequest!) -> Bool
    {
        let schemeIsMock = request.URL.scheme == "mock"
        var urlMatched = responsesForURL(request.URL)?.count > 0
        
        return (schemeIsMock && urlMatched)
    }
    
    override public class func canonicalRequestForRequest(request: NSURLRequest!) -> NSURLRequest!
    {
        return request
    }
    
    override public class func requestIsCacheEquivalent(a: NSURLRequest!, toRequest b: NSURLRequest!) -> Bool
    {
        return a.URL == b.URL
    }
    
    override public func startLoading()
    {
        let request = self.request
        let client: NSURLProtocolClient = self.client
        
        if let cannedResponses = self.dynamicType.responsesForURL(request.URL)
            {
                let cannedResponse: MockWebServiceResponse = cannedResponses[0]
                if let error = cannedResponse.error
                {
                    client.URLProtocol(self, didFailWithError: error)
                }
                else
                {
                    let response = NSHTTPURLResponse(URL: request.URL, statusCode: cannedResponse.statusCode, HTTPVersion: "HTTP/1.1", headerFields: cannedResponse.header)
                    client.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: NSURLCacheStoragePolicy.NotAllowed)
                    
                    let jsonData = NSJSONSerialization.dataWithJSONObject(cannedResponse.body, options: NSJSONWritingOptions(), error: nil)
                    client.URLProtocol(self, didLoadData: jsonData)
                    
                    client.URLProtocolDidFinishLoading(self)
                }
                
            }

    }
    
    override public func stopLoading()
    {
        
    }
}