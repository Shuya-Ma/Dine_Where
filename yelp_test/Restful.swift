//
//  Restful.swift
//  yelp_test
//
//  Created by Kevin Lin on 11/14/16.
//  Copyright © 2016 Kevin Lin. All rights reserved.
//

import Foundation
import Alamofire

class restfulCollection<R: restfulItem> {
    var items = [R]()
    
    var fetching: Bool = false
    var failed: Bool = false
    var done: Bool = false
    var total: Int = 0
    var full: Bool = false
    
    var count: Int {
        get {
            return self.items.count
        }
    }
    
    internal func request() -> Alamofire.Request? {
        return nil
    }
    internal func requestMore(more: Bool) -> Alamofire.Request? {
        return nil
    }
    
    internal func response(response: Response<AnyObject, NSError>, rawData: Any?) -> [NSDictionary]? {
        return nil
    }
    
    func fetch(done done: (restfulCollection<R>) -> Void, fail: (NSError?) -> Void) {
        if fetching {
            return
        }
        
        fetching = true
        full = false
        
        request()?.responseJSON { response in
            if let error = response.result.error {
                self.fetching = false
                self.failed = true
                
                fail(error)
                return
            }
            
            if let _ = response.result.value {
                //print(response.result.value)
                self.fetching = false
                self.failed = false
                self.done = true
                
                self.items = self.response(response, rawData: nil)!.map { rawData in
                    return R(rawData: rawData)
                }
                
                done(self)
            }
        }
    }
    
    
    func fetchMore(done done: (restfulCollection<R>) -> Void, fail: (NSError?) -> Void) {
        if fetching {
            return
        }
        
        fetching = true
        requestMore(true)?.responseJSON { response in
            if let error = response.result.error {
                self.fetching = false
                self.failed = true
                
                fail(error)
                return
            }
            
            if let _ = response.result.value {
                let prevCount = self.count
                
                self.fetching = false
                self.failed = false
                
                self.items += self.response(response, rawData: nil)!.map { rawData in
                    return R(rawData: rawData)
                }
                
                if (self.count == prevCount) {
                    self.full = true
                }
                
                done(self)
            }
        }
    }
    
    func get(index: Int) -> R? {
        return index < items.count ? self.items[index] : nil
    }
}


protocol restfulItem {
    init(rawData: NSDictionary)
}
