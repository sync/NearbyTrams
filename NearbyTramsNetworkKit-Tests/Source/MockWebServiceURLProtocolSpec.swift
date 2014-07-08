//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsNetworkKit

class MockWebServiceURLProtocolSpec: QuickSpec {
    override func spec() {
        describe("MockWebServiceResponse") {
            var response: MockWebServiceResponse!
            var error: NSError!
            
            describe("Init") {
                beforeEach {
                    error = NSError(domain: "au.com.test.domain", code: 150, userInfo: nil)
                    response = MockWebServiceResponse(body: ["test": "blah"], header: ["Content-Type": "application/json; charset=utf-8"], statusCode: 404, error: error)
                }
                
                it("should have a body") {
                    expect(response.body as NSDictionary).to.equal(["test": "blah"])
                }
                
                it("should have an header") {
                    expect(response.header).to.equal(["Content-Type": "application/json; charset=utf-8"])
                }
                
                it("should have a statusCode") {
                    expect(response.statusCode).to.equal(404)
                }
                
                it("should have an error") {
                    expect(response.error).to.equal(error)
                }
            }
        }
        
        describe("MockWebServiceURLProtocol") {
            beforeEach {
                let response = MockWebServiceResponse(body: ["test": "blah"], header: ["Content-Type": "application/json; charset=utf-8"])
                MockWebServiceURLProtocol.cannedResponse(response)
            }
            
            afterEach {
                MockWebServiceURLProtocol.cannedResponse(nil)
            }
            

            describe("canInitWithRequest") {
                context("without a url component to match") {
                    context("when using mock scheme") {
                        it("should be able to init a request") {
                            let request = NSURLRequest(URL: NSURL(string: "mock://www.apple.com"))
                            expect(MockWebServiceURLProtocol.canInitWithRequest(request)).to.beTrue()
                        }
                    }
                    
                    context("when using http scheme") {
                        it("should not be able to init a request") {
                            let request = NSURLRequest(URL: NSURL(string: "http://www.apple.com"))
                            expect(MockWebServiceURLProtocol.canInitWithRequest(request)).to.beFalse()
                        }
                    }
                }
                
                context("with a url component to match") {
                    beforeEach {
                        let response = MockWebServiceResponse(body: ["test": "blah"], header: ["Content-Type": "application/json; charset=utf-8"], urlComponentToMatch:"GetStopsByRouteAndDirection.ashx")
                        let responseNoComponent = MockWebServiceResponse(body: ["test2": "blah"], header: ["Content-Type": "application/json; charset=utf-8"])
                        MockWebServiceURLProtocol.cannedResponses([response, responseNoComponent])
                    }
                    
                    it("should be able to init a request") {
                        let request = NSURLRequest(URL: NSURL(string: "mock://www.apple.com/Controllers/GetStopsByRouteAndDirection.ashx?r=123&u=true"))
                        expect(MockWebServiceURLProtocol.canInitWithRequest(request)).to.beTrue()
                    }
                }
            }
            
            describe("canonicalRequestForRequest") {
                it("should return the same request") {
                    let request = NSURLRequest(URL: NSURL(string: "mock://www.apple.com"))
                    expect(MockWebServiceURLProtocol.canonicalRequestForRequest(request)).to.equal(request)
                }
            }
            
            describe("requestIsCacheEquivalent") {
                context("when given requests are equal") {
                    it("should be equivalent with the same request is given twice") {
                        let requestA = NSURLRequest(URL: NSURL(string: "mock://www.apple.com"))
                        let requestB = NSURLRequest(URL: NSURL(string: "mock://www.apple.com"))
                        expect(MockWebServiceURLProtocol.requestIsCacheEquivalent(requestA, toRequest: requestB )).to.beTrue()
                    }
                }
                
                context("when given requests aren't equal") {
                    it("should be equivalent with the same request is given twice") {
                        let requestA = NSURLRequest(URL: NSURL(string: "mock://www.apple.com"))
                        let requestB = NSURLRequest(URL: NSURL(string: "http://www.apple.com"))
                        expect(MockWebServiceURLProtocol.requestIsCacheEquivalent(requestA, toRequest: requestB )).to.beFalse()
                    }
                }
            }
            
            // startLoading is tested inside NetworkServiceSpec
        }
    }
}

