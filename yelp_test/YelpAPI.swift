//
//  YelpAPI.swift
//  yelp_test
//
//  Created by Kevin Lin on 11/7/16.
//  Copyright © 2016 Kevin Lin. All rights reserved.
//

import OAuthSwift
import Alamofire

class YelpAccess {
    static let sharedInstance = YelpAccess()
    private let APIurl = "https://api.yelp.com/v2"
    
    // Yelp API key and token
    private let oAuthClient = {() -> OAuthSwiftClient in
        let oAuthClient = OAuthSwiftClient(
            consumerKey: "DhKqfsCr9E2pu_w1fzbDhQ",
            consumerSecret: "j75DLVQkY3g-RMjoCxmyoChXybw",
            accessToken: "_c7lkabTgDF2Erwxl2kO33DZRC_TJSZO",
            accessTokenSecret: "AIMGr47gn7SNdFDUX1LNrFxbDXI"
        )
        oAuthClient.credential.oauth_header_type = "oauth1"
        return oAuthClient
    }()
    
    // Request through Alamofire
    func request(method: Alamofire.Method, path: String, parameters: [String: AnyObject], usingCache: Bool = false) -> Request {
        let urlString = "\(APIurl)\(path)"
        let headers = oAuthClient.credential.makeHeaders(NSURL(string:urlString)!, method: String(method), parameters: parameters)
        var request = Alamofire.request(method, urlString, parameters: parameters, encoding: .URL, headers: headers)
        if(!usingCache) {
            let mutableReq = request.request as! NSMutableURLRequest
            mutableReq.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            request = Alamofire.request(mutableReq)
        }
        return request
    }
}

// Filters
extension YelpAccess {
    struct Filters {
        static let distances: [[String: AnyObject]] = [
            ["label": "Auto", "value": 0],
            ["label": "0.3 miles", "value": 482.8032],
            ["label": "1 mile", "value": 1609.344],
            ["label": "5 miles", "value": 8046.720],
            ["label": "20 miles", "value": 32186.88]
        ]
        static let deal: [String: AnyObject] = [
            "label": "Offer a Deal",
            "value": true
        ]
        static let sorts:[[String: AnyObject]] = [
            ["label": "Best matched", "value": 0],
            ["label": "Distance", "value": 1],
            ["label": "High rated", "value": 2]
        ]
    }
}