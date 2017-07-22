//
//  DetailViewController.swift
//  yelp_test
//
//  Created by KaiHsun Hsu on 12/4/16.
//  Copyright © 2016 Kevin Lin. All rights reserved.
//

import UIKit
import MapKit
import AddressBook

var initialLocation:CLLocationCoordinate2D!


class DetailViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingStarView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    var diner : Diner!
    let restaurantIcon = UIImage(named: "restaurant")
    var restaurantFromMap : [RestaurantLocation] = []
    var nameFromMap: String!
    
    
    //MARK: - Map setup
    func resetRegion(){
        let region = MKCoordinateRegionMakeWithDistance(initialLocation, 500, 500)
        mapView.setRegion(region, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var restaurants: [RestaurantLocation] = []
        
        //        let lat = Double(diner.latitude)
        //        let long = Double(diner.longitude)
        //        let name = diner.name
        //
        //        var address = diner.address
        //        var d_rating = diner.rating
        //        var reviewCount = diner.reviewCount
        //        var distance = diner.distance
        //        var imageUrl = diner.imageUrl
        var lat: Double = 0
        var long: Double = 0
        var name: String = ""
        var address: String = ""
        var d_rating: Float = 0
        var d_reviewCount: Float = 0
        var distance: Float = 0.0
        var imageUrl: String = ""
        
        if restaurantFromMap.isEmpty {
            lat = Double(diner.latitude)
            long = Double(diner.longitude)
            name = diner.name
            address = diner.address!
            d_rating = diner.rating!
            d_reviewCount = diner.reviewCount!
            distance = diner.distance!
            imageUrl = diner.imageUrl!
        }
        
        restaurantFromMap.forEach { restaurant in
            if(restaurant.title == nameFromMap) {
                lat = restaurant.coordinate.latitude
                long = restaurant.coordinate.longitude
                name = restaurant.title!
                
                address = restaurant.d_address!
                d_rating = restaurant.d_rating!
                d_reviewCount = restaurant.d_reviewCount!
                distance = restaurant.d_distance!
                imageUrl = restaurant.d_imageUrl!
            }
        }
        
        let info = RestaurantLocation(name: name,address: address,rating: d_rating,reviewCount: d_reviewCount,distance: distance,imageUrl: imageUrl,lat: lat, long: long)
        restaurants += [info]
        
        let initialLocationNew = CLLocationCoordinate2DMake(lat,long)
        initialLocation = initialLocationNew
        
        resetRegion()
        mapView.addAnnotations(restaurants)
        mapView.delegate = self
        ratingStarView.backgroundColor = UIColor.clearColor()
        
        
        nameLabel.text = name
        addressLabel.text = address
        let met = distance
        distanceLabel.text = String(format: "%.2f miles", arguments: [met/1609.344])
        
        var rating = d_rating
        ratingLabel.text = String(format: "%.1f", arguments: [rating])
        
        let reviewCount = d_reviewCount
        print(reviewCount)
        let revCount = Int(reviewCount)
        reviewCountLabel.text = String("\(revCount) reviews")
        
        let imageURLString = imageUrl
        previewImageView.clipsToBounds = true
        previewImageView.contentMode = .ScaleAspectFill
        previewImageView.af_setImageWithURL(NSURL(string: imageURLString)!, imageTransition: .CrossDissolve(0.2))
        
        
        ratingStarView.backgroundColor = UIColor.clearColor()
        
        ratingStarView.subviews.forEach { starView in
            starView.removeFromSuperview()
        }
        
        //        var rating: Float = 0
        
        let r = d_rating
        rating = r
        
        
        for i in 1...5 {
            var imageName = "star-none"
            
            if rating >= Float(i) {
                imageName = "star-full"
                
            } else if rating > Float(i - 1) {
                imageName = "star-half"
            }
            
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.frame = CGRectMake(CGFloat((i - 1) * 12), 0, 10, 10)
            
            ratingStarView.addSubview(imageView)
        }
        
    }
    
    //MARK: - Annotations
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? RestaurantLocation{
            if let view = mapView.dequeueReusableAnnotationViewWithIdentifier(annotation.identifier){
                return view
            }else{
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
                view.image = restaurantIcon
                view.enabled = true
                view.canShowCallout = true
                let smallSquare = CGSize(width: 60, height: 60)
                let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
                button.setBackgroundImage(UIImage(named: "car"), forState: .Normal)
                view.leftCalloutAccessoryView = button
                
                
                return view
            }
        }
        
        return nil
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! RestaurantLocation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
    
    
    
}






