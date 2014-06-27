//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Foundation

struct MockWebServiceResponse
{
    let body: AnyObject
    let header: Dictionary<String, AnyObject>
    let statusCode: Int
    let error: NSError?
    
    init (body: AnyObject, header: Dictionary<String, AnyObject>, statusCode: Int = 200, error: NSError? = nil)
    {
        self.body = body
        self.header = header
        self.statusCode = statusCode
        self.error = error
    }
}

struct MockWebServiceResponseStorage
{
    static var storage: MockWebServiceResponse?
}

class MockWebServiceURLProtocol: NSURLProtocol
{
    class var cannedResponse:(response: MockWebServiceResponse!) {
        get {
             return MockWebServiceResponseStorage.storage
        }
        set {
            MockWebServiceResponseStorage.storage = newValue
        }
    }
    
    override class func canInitWithRequest(request: NSURLRequest!) -> Bool
    {
        return request.URL.scheme == "mock"
    }
    
    override class func canonicalRequestForRequest(request: NSURLRequest!) -> NSURLRequest!
    {
        return request
    }
    
    override class func requestIsCacheEquivalent(a: NSURLRequest!, toRequest b: NSURLRequest!) -> Bool
    {
        return a.URL == b.URL
    }
    
    override func startLoading()
    {
        let request = self.request
        let client: NSURLProtocolClient = self.client
        
        if MockWebServiceURLProtocol.cannedResponse != nil
        {
            let cannedResponse: MockWebServiceResponse = MockWebServiceURLProtocol.cannedResponse
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
    
    override func stopLoading()
    {
        
    }
}