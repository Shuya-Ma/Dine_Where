//
//  MapViewController.swift
//  yelp_test
//
//  Created by KaiHsun Hsu on 12/1/16.
//  Copyright © 2016 Kevin Lin. All rights reserved.
//

import UIKit
import MapKit
import AddressBook

//MARK: Global Declarations
let wustlCoordinate = CLLocationCoordinate2DMake(38.6487895,-90.3107962)
class MapViewController: UIViewController,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var restaurants: [RestaurantLocation] = []
    var diners: dinerCollection!
    let locationManager = CLLocationManager()
    let restaurantIcon = UIImage(named: "restaurant")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        diners.items.forEach { diner in
            
            let lat = CLLocationDegrees(diner.latitude)
            let long = CLLocationDegrees(diner.longitude)
            let name = diner.name
            let address = diner.address
            let d_rating = diner.rating
            let reviewCount = diner.reviewCount
            let distance = diner.distance
            let imageUrl = diner.imageUrl
            let info = RestaurantLocation(name: name,address: address!,rating: d_rating!,reviewCount: reviewCount!,distance: distance!,imageUrl: imageUrl!,lat: lat, long: long)
            restaurants += [info]
            
        }
        mapView.addAnnotation(WustlCenterCoordinate())
        mapView.addAnnotations(restaurants)
        mapView.delegate = self
        
        
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
                //                let smallSquare = CGSize(width: 60, height: 60)
                //                let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
                //                button.setBackgroundImage(UIImage(named: "car"), forState: .Normal)
                //                view.leftCalloutAccessoryView = button
                view.rightCalloutAccessoryView = UIButton(type:.DetailDisclosure) as! UIView
                
                
                return view
            }
        }
        
        return nil
    }
    
    
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        performSegueWithIdentifier("detailSegue", sender: view)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue"{
            let detailViewController = segue.destinationViewController as! DetailViewController
            let pin = sender as? MKAnnotationView
            detailViewController.restaurantFromMap = restaurants
            detailViewController.nameFromMap = (pin?.annotation?.title)!
            
        }
    }
}


class WustlCenterCoordinate: NSObject,MKAnnotation{
    var coordinate: CLLocationCoordinate2D = wustlCoordinate
    var title: String? = "Washington University"
}


extension MapViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: (error)")
    }
    
}


