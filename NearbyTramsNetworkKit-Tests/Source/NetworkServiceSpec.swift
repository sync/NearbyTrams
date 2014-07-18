//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsNetworkKit

class NetworkServiceSpec: QuickSpec {
    override func spec() {
        var service: NetworkService!
        
        describe("Init") {
            context("when provided with a basURL") {
                beforeEach {
                    service = NetworkService(baseURL: NSURL(string: "http://www.apple.com"))
                }
                
                it("should have a baseURL") {
                    expect(service.baseURL.absoluteString).to.equal("http://www.apple.com")
                }
            }
            
            context("when provided with a configuration") {
                
                var configuration: NSURLSessionConfiguration?
                
                beforeEach {
                    configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
                    service = NetworkService(configuration: configuration!)
                }
                
                it("should have a configuration") {
                    expect(service.configuration).to.equal(configuration)
                }
            }
        }
        
        describe("getAllRoutesWithCompletionHandler") {
            beforeEach {
                let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
                let urlProcolClass: AnyObject = ClassUtility.classFromType(MockWebServiceURLProtocol.self)
                configuration.protocolClasses = [urlProcolClass]
                
                service = NetworkService(baseURL: NSURL(string: "mock://www.apple.com"), configuration: configuration)
            }
            
            it("should return a session data task") {
                let task = service.getAllRoutesWithCompletionHandler(nil)
                
                expect(task).notTo.beNil()
            }
            
            context("when an error occur") {
                
                var error: NSError!
                
                beforeEach {
                    error = NSError(domain: "au.com.otherTest.domain", code: 150, userInfo: nil)
                    let response = MockWebServiceResponse(body: ["test": "blah"], header: ["Content-Type": "application/json; charset=utf-8"], statusCode: 404, error: error)
                    MockWebServiceURLProtocol.cannedResponse(response)
                }
                
                afterEach {
                    MockWebServiceURLProtocol.cannedResponse(nil)
                }
                
                it("should complete with an error") {
                    
                    var array: NSDictionary[]!
                    var completionError: NSError!
                    
                    let task = service.getAllRoutesWithCompletionHandler {
                        routes, error -> Void in
                        
                        array = routes
                        completionError = error
                    }
                    
                    expect{array}.will.beNil()
                    expect{completionError}.will.equal(error)
                }
            }
            
            context("when successful") {
                
                var responseObject: Dictionary<String, AnyObject>[]!
                
                beforeEach {
                    responseObject = [["test": "blah"], ["test": "blah"]]
                    let response = MockWebServiceResponse(body: ["responseObject": responseObject], header: ["Content-Type": "application/json; charset=utf-8"])
                    MockWebServiceURLProtocol.cannedResponse(response)
                }
                
                afterEach {
                    MockWebServiceURLProtocol.cannedResponse(nil)
                }
                
                it("should complete with a dictionary and no error") {
                    
                    var array: NSDictionary[]!
                    var completionError: NSError!
                    
                    let task = service.getAllRoutesWithCompletionHandler {
                        routes, error -> Void in
                        
                        array = routes
                        completionError = error
                        }
                    
                    expect{array}.will.equal(responseObject)
                    expect{completionError}.will.beNil()
                }
            }
        }
        
        describe("getStopsByRouteAndDirectionWithRouteNo") {
            beforeEach {
                let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
                let urlProcolClass: AnyObject = ClassUtility.classFromType(MockWebServiceURLProtocol.self)
                configuration.protocolClasses = [urlProcolClass]
                
                service = NetworkService(baseURL: NSURL(string: "mock://www.apple.com"), configuration: configuration)
            }
            
            it("should return a session data task") {
                let task = service.getStopsByRouteAndDirectionWithRouteNo(123, isUpStop: true, completionHandler: nil)
                
                expect(task).notTo.beNil()
            }
            
            it("should have added to the query url the stop no") {
                //originalRequest
                let task = service.getStopsByRouteAndDirectionWithRouteNo(123, isUpStop: true, completionHandler: nil)
                
                expect(task.originalRequest.URL.absoluteString).to.contain("123")
            }
            
            context("when an error occur") {
                
                var error: NSError!
                
                beforeEach {
                    error = NSError(domain: "au.com.otherTest.domain", code: 150, userInfo: nil)
                    let response = MockWebServiceResponse(body: ["test": "blah"], header: ["Content-Type": "application/json; charset=utf-8"], statusCode: 404, error: error)
                    MockWebServiceURLProtocol.cannedResponse(response)
                }
                
                afterEach {
                    MockWebServiceURLProtocol.cannedResponse(nil)
                }
                
                it("should complete with an error") {
                    
                    var array: NSDictionary[]!
                    var completionError: NSError!
                    
                    let stopInfoTask = service.getStopsByRouteAndDirectionWithRouteNo(123, isUpStop: true, {
                        stops, error -> Void in
                        
                        array = stops
                        completionError = error
                        })
                    
                    expect{array}.will.beNil()
                    expect{completionError}.will.equal(error)
                }
            }
            
            context("when successful") {
                
                var responseObject: Dictionary<String, AnyObject>[]!
                
                beforeEach {
                    responseObject = [["test": "blah"], ["test": "blah"]]
                    let response = MockWebServiceResponse(body: ["responseObject": responseObject], header: ["Content-Type": "application/json; charset=utf-8"])
                    MockWebServiceURLProtocol.cannedResponse(response)
                }
                
                afterEach {
                    MockWebServiceURLProtocol.cannedResponse(nil)
                }
                
                it("should complete with a dictionary and no error") {
                    
                    var array: NSDictionary[]!
                    var completionError: NSError!
                    
                    let task = service.getStopsByRouteAndDirectionWithRouteNo(123, isUpStop: true, {
                        stops, error -> Void in
                        
                        array = stops
                        completionError = error
                        })
                    
                    expect{array}.will.equal(responseObject)
                    expect{completionError}.will.beNil()
                }
            }
        }
        
        describe("getStopInformationWithStopNo") {
            beforeEach {
                let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
                let urlProcolClass: AnyObject = ClassUtility.classFromType(MockWebServiceURLProtocol.self)
                configuration.protocolClasses = [urlProcolClass]
                
                service = NetworkService(baseURL: NSURL(string: "mock://www.apple.com"), configuration: configuration)
            }
            
            it("should return a session data task") {
                let task = service.getStopInformationWithStopNo(123, completionHandler: nil)
                
                expect(task).notTo.beNil()
            }
            
            it("should have added to the query url the stop no") {
                //originalRequest
                let task = service.getStopInformationWithStopNo(123, completionHandler: nil)
                
                expect(task.originalRequest.URL.absoluteString).to.contain("123")
            }
            
            context("when an error occur") {
                
                var error: NSError!
                
                beforeEach {
                    error = NSError(domain: "au.com.otherTest.domain", code: 150, userInfo: nil)
                    let response = MockWebServiceResponse(body: ["test": "blah"], header: ["Content-Type": "application/json; charset=utf-8"], statusCode: 404, error: error)
                    MockWebServiceURLProtocol.cannedResponse(response)
                }
                
                afterEach {
                    MockWebServiceURLProtocol.cannedResponse(nil)
                }
                
                it("should complete with an error") {
                    
                    var dictionary: NSDictionary!
                    var completionError: NSError!
                    
                    let stopInfoTask = service.getStopInformationWithStopNo(123, {
                        stop, error -> Void in
                        
                        dictionary = stop
                        completionError = error
                        })
                    
                    expect{dictionary}.will.beNil()
                    expect{completionError}.will.equal(error)
                }
            }
            
            context("when successful") {
                
                var responseObject: Dictionary<String, AnyObject>!
                
                beforeEach {
                    responseObject = ["test": "blah"]
                    let response = MockWebServiceResponse(body: ["responseObject": responseObject], header: ["Content-Type": "application/json; charset=utf-8"])
                    MockWebServiceURLProtocol.cannedResponse(response)
                }
                
                afterEach {
                    MockWebServiceURLProtocol.cannedResponse(nil)
                }
                
                it("should complete with a dictionary and no error") {
                    
                    var dictionary: NSDictionary!
                    var completionError: NSError!
                    
                    let task = service.getStopInformationWithStopNo(123, {
                        stop, error -> Void in
                        
                        dictionary = stop
                        completionError = error
                        })
                    
                    expect{dictionary}.will.equal(responseObject)
                    expect{completionError}.will.beNil()
                }
            }
        }
        
        describe("getNextPredictionsWithStopNo") {
            beforeEach {
                let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
                let urlProcolClass: AnyObject = ClassUtility.classFromType(MockWebServiceURLProtocol.self)
                configuration.protocolClasses = [urlProcolClass]
                
                service = NetworkService(baseURL: NSURL(string: "mock://www.apple.com"), configuration: configuration)
            }
            
            it("should return a session data task") {
                let task = service.getNextPredictionsWithStopNo(123, completionHandler: nil)
                
                expect(task).notTo.beNil()
            }
            
            it("should have added to the query url the stop no and a zero route no") {
                //originalRequest
                let task = service.getNextPredictionsWithStopNo(123, completionHandler: nil)
                
                expect(task.originalRequest.URL.absoluteString).to.contain("/123/")
                expect(task.originalRequest.URL.absoluteString).to.contain("/0/")
            }
            
            it("should have added to the query url the stop no and the route no") {
                //originalRequest
                let task = service.getNextPredictionsWithStopNo(456, routeNo: "16", completionHandler: nil)
                
                expect(task.originalRequest.URL.absoluteString).to.contain("/456/")
                expect(task.originalRequest.URL.absoluteString).to.contain("/16/")
            }
            
            context("when an error occur") {
                
                var error: NSError!
                
                beforeEach {
                    error = NSError(domain: "au.com.otherTest.domain", code: 150, userInfo: nil)
                    let response = MockWebServiceResponse(body: ["test": "blah"], header: ["Content-Type": "application/json; charset=utf-8"], statusCode: 404, error: error)
                    MockWebServiceURLProtocol.cannedResponse(response)
                }
                
                afterEach {
                    MockWebServiceURLProtocol.cannedResponse(nil)
                }
                
                it("should complete with an error") {
                    
                    var array: NSDictionary[]!
                    var completionError: NSError!
                    
                    let stopInfoTask = service.getNextPredictionsWithStopNo(123, completionHandler: {
                        predictions, error -> Void in
                        
                        array = predictions
                        completionError = error
                        })
                    
                    expect{array}.will.beNil()
                    expect{completionError}.will.equal(error)
                }
            }
            
            context("when successful") {
                
                var responseObject: Dictionary<String, AnyObject>[]!
                
                beforeEach {
                    responseObject = [["test": "blah"], ["test": "blah"]]
                    let response = MockWebServiceResponse(body: ["responseObject": responseObject], header: ["Content-Type": "application/json; charset=utf-8"])
                    MockWebServiceURLProtocol.cannedResponse(response)
                }
                
                afterEach {
                    MockWebServiceURLProtocol.cannedResponse(nil)
                }
                
                it("should complete with a dictionary and no error") {
                    
                    var array: NSDictionary[]!
                    var completionError: NSError!
                    
                    let task = service.getNextPredictionsWithStopNo(123, completionHandler: {
                        predictions, error -> Void in
                        
                        array = predictions
                        completionError = error
                        })
                    
                    expect{array}.will.equal(responseObject)
                    expect{completionError}.will.beNil()
                }
            }
        }
    }
}

