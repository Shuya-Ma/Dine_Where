//
//  diner.swift
//  yelp_test
//
//  Created by Kevin Lin on 11/8/16.
//  Copyright © 2016 Kevin Lin. All rights reserved.
//

import Alamofire
import Dollar
import MapKit


class Diner: restfulItem {
    
    
    let name: String
    let address: String?
    let phone: String?
    let rating: Float?
    let reviewCount: Float?
    let distance: Float?
    let imageUrl: String?
    let latitude: Float
    let longitude: Float
    
    required init(rawData: NSDictionary) {
        name = rawData["name"] as! String
        phone = rawData["phone"] as? String
        rating = rawData["rating"] as? Float
        reviewCount = rawData["review_count"] as? Float
        distance = rawData["distance"] as? Float
        latitude = rawData.valueForKeyPath("location.coordinate.latitude") as! Float
        longitude = rawData.valueForKeyPath("location.coordinate.longitude") as! Float
        
        imageUrl = {() -> String? in
            if let url = rawData["image_url"] as? String {
                let regex = try! NSRegularExpression(pattern: "/ms", options: .CaseInsensitive)
                return regex.stringByReplacingMatchesInString(url, options: [], range: NSRange(0...url.utf16.count-1), withTemplate: "/sl")
            }
            return nil
        }()
        
        let addressPieces = rawData.valueForKeyPath("location.display_address") as! [String]
        if addressPieces.count > 2 {
            address = Array(addressPieces[0...1]).joinWithSeparator(", ")
        }
        else {
            address = addressPieces.joinWithSeparator(", ")
        }
    }
}

class dinerCollection: restfulCollection<Diner> {
    var offset = 0
    let limit  = 20
    var term = ""
    var deals: Bool = false
    var distance: Float = 0
    var sort: Int = 0
    var categories: [String: Bool] = [:]
    
    //temp init location
    var initLocation: [String: AnyObject] = [
        "ll": "38.649007, -90.310770"
    ]
    
    var parameters: [String: AnyObject] {
        get {
            var parameters = $.merge(initLocation, [
                "term": term,
                "limit": limit,
                "offset": offset,
                "deals_filter": deals,
                "sort": sort
                ])
            parameters["category_filter"] = "restaurants" ////// search for food category only
            if distance != 0 {
                parameters = $.merge(parameters, ["radius": distance])
            }
            return parameters
        }
    }
    
    func filteringCopy() -> dinerCollection {
        let dinerCollectionCopy = dinerCollection()
        dinerCollectionCopy.term = term
        dinerCollectionCopy.deals = deals
        dinerCollectionCopy.distance = distance
        dinerCollectionCopy.categories = categories
        return dinerCollectionCopy
    }
    
    override func request() -> Request? {
        offset = 0
        return YelpAccess.sharedInstance.request(
            .GET,
            path: "/search",
            parameters: parameters
        );
    }
    
    override func requestMore(more: Bool) -> Request? {
        return YelpAccess.sharedInstance.request(
            .GET,
            path: "/search",
            parameters: parameters
        );
    }

    override func response(response: Response<AnyObject, NSError>, rawData: Any?) -> [NSDictionary]? {
        let castedRawData = response.result.value!["businesses"] as? [NSDictionary]
        if let count = castedRawData?.count {
            offset += count
        }
        return castedRawData
    }
}




