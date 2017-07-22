//
//  restaurant.swift
//  yelp_test
//
//  Created by KaiHsun Hsu on 12/1/16.
//  Copyright © 2016 Kevin Lin. All rights reserved.
//

import UIKit
import MapKit
import AddressBook


class RestaurantLocation: NSObject, MKAnnotation{
    
    
    var identifier = "Restaurant location"
    
    var title: String?
    var d_address: String?
    var d_rating: Float?
    var d_reviewCount: Float?
    var d_distance: Float?
    var d_imageUrl: String?
    
    var coordinate: CLLocationCoordinate2D
    init(name:String,address:String,rating:Float,reviewCount:Float,distance:Float,imageUrl:String,lat:CLLocationDegrees,long:CLLocationDegrees){
        title = name
        d_address = address
        d_rating = rating
        d_reviewCount = reviewCount
        d_distance = distance
        d_imageUrl = imageUrl
        coordinate = CLLocationCoordinate2DMake(lat, long)
        
    }
    
    var subtitle: String? {
        return title
    }
    
    
    // annotation callout info button opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): self.subtitle as! AnyObject]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    
    
}


