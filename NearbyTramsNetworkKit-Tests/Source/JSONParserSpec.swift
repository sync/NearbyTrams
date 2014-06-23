//
//  Copyright (c) 2014 Dblechoc. All rights reserved.
//

import Quick
import Nimble
import NearbyTramsNetworkKit

class JSONParserSpec: QuickSpec {
    override func spec() {
        describe("parseJSON") {
            context("with empty data") {
                it("should return an error") {
                    let data = NSData()
                    let (object : AnyObject?, error) = JSONParser.parseJSON(data)
                    
                    expect(error).notTo.beNil()
                }
            }
            
            context("with data representing a dictionary") {
                
                var data: NSData! = nil
                var dictionary: Dictionary<String, String>! = nil
                
                beforeEach {
                    dictionary = ["key": "value"]
                    
                    data = NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions(), error: nil)
                }
                
                it("should return a dictionary") {
                    let (object : AnyObject?, error) = JSONParser.parseJSON(data)
                    let keyValueDict = object as? NSDictionary
                    
                    expect(keyValueDict).to.equal(dictionary)
                }
            }
        }
    }
}

