//
//  DinerTableViewController.swift
//  yelp_test
//
//  Created by Kevin Lin on 11/7/16.
//  Copyright © 2016 Kevin Lin. All rights reserved.
//

import UIKit
import MapKit

class DinerTableViewController: UIViewController ,MKMapViewDelegate {
    @IBOutlet var thetableview: UITableView!
    @IBOutlet weak var searchBarView: SearchBarView!
    @IBOutlet weak var queryTextField: UITextField!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var dinerView: DinerTableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    var diners = dinerCollection()
    var filteredDiners: dinerCollection!
    let refreshControl = UIRefreshControl()
    let locationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
//        let lat = String(locationManager.location!.coordinate.latitude)
//        let long = String(locationManager.location!.coordinate.longitude)
//        let updateloca:[String: AnyObject] = ["ll": "\(lat), \(long)"]
//        diners.initLocation = updateloca
        //navigationItem.titleView = UIImageView(image: UIImage(named: "yelp-nav-icon"))
        dinerView.dataSource = self
        dinerView.delegate = self
        refreshControl.tintColor = UIColor.lightGrayColor()
        refreshControl.addTarget(self, action: #selector(DinerTableViewController.refresh(_:)), forControlEvents: .ValueChanged)
        dinerView.addSubview(refreshControl)
        activityIndicator.startAnimating()
        renderSearchBar()
        hideSearchBar(false)
        
        getDiners {}
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl.endRefreshing()
        if dinerView.indexPathForSelectedRow != nil {
            dinerView.deselectRowAtIndexPath(dinerView.indexPathForSelectedRow!, animated: false)
        }
    }
    
    func scrollToTop(animated: Bool) {
        let firstRowIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        dinerView.scrollToRowAtIndexPath(firstRowIndexPath, atScrollPosition: .Top, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mapSegue" {
            let mapViewController = segue.destinationViewController as! MapViewController
            mapViewController.diners = diners
        }
        if segue.identifier == "detailSegue"{
            let detailViewController = segue.destinationViewController as! DetailViewController
            let cell = sender as! dinerTableViewCell
            detailViewController.diner = cell.diner
        }
        if segue.identifier == "filterSegue" {
            filteredDiners = diners.filteringCopy()
            let filterViewController = segue.destinationViewController as! FilterViewController
            filterViewController.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

// Search Bar manipulation
extension DinerTableViewController {
    func renderSearchBar() {
        filterButton.tintColor = UIColor.whiteColor()
    }
    
    @IBAction func handleQueryChange(sender: UITextField) {
        diners = diners.filteringCopy()
        diners.term = sender.text!
        print("search/(sender.text)")
        dinerView.reloadData()
        view.endEditing(true)
        getDiners(){}
    }
    
    func showSearchBar(animated: Bool) {
        func layout() {
            self.searchBarHeightConstraint.constant = 45
            print(self.searchBarHeightConstraint.constant)
            self.view.layoutIfNeeded()
        }
        
        if (!animated) {
            layout()
            return
        }
        
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseOut, animations: layout, completion: { _ in });
    }
    
    func hideSearchBar(animated: Bool) {
        func layout() {
            self.searchBarHeightConstraint.constant = 0
            print(self.searchBarHeightConstraint.constant)
            self.view.layoutIfNeeded()
        }
        
        view.endEditing(true)
        
        if (!animated) {
            layout()
            return
        }
        
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseOut, animations: layout, completion: { _ in });
    }

    @IBAction func handleSearchBarTap(sender: UIBarButtonItem) {
        print("tapped")
        if searchBarHeightConstraint.constant == 0 {
            showSearchBar(true)
        }
        else {
            hideSearchBar(true)
        }
    }
}

// Obtain Data
extension DinerTableViewController {
    func getDiners(done: () -> Void) {
        activityIndicator.hidden = false
        diners.fetch(
            done: { _ in
                self.dinerView.reloadData()
                done()
            },
            fail: {_ in}
        )
    }
    
    func getMoreDiners() {
        if !diners.done || diners.full {
            return
        }
        
        diners.fetchMore(
            done: { _ in
                if self.diners.full {
                    self.activityIndicator.hidden = true
                }
                self.dinerView.reloadData()
            },
            fail: { _ in }
        )
    }
    
    func refresh(sender: AnyObject) {
        self.refreshControl.beginRefreshing()
        getDiners {
            dispatch_async(dispatch_get_main_queue()) {
                self.refreshControl.endRefreshing()
            }
        }
    }
}

//Table manipullation
extension DinerTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dinerCell") as! dinerTableViewCell
        cell.diner = diners.get(indexPath.row)
        cell.renewData()
        if indexPath.row >= diners.count - 10 {
            getMoreDiners()
        }
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(diners.count)
        return diners.count
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

// Location manipulation
extension DinerTableViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            //mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: (error)")
    }
}


// Filter manipulation
extension DinerTableViewController: FilterViewDelegate {
    func filterView(isCellActiveForFilterWithName name: FilterViewController.FilterName, filterValue value: AnyObject) -> Bool {
        switch name {
        case .Deals:
            return filteredDiners.deals
            
        case .Distance:
            return filteredDiners.distance == value as! Float
            
        case .Sort:
            return filteredDiners.sort == value as! Int
        }
    }
    
    func filterView(valueForFilterWithName name: FilterViewController.FilterName) -> AnyObject {
        switch name {
        case .Distance:
            return filteredDiners.distance
            
        case .Sort:
            return filteredDiners.sort
            
        default:
            return ""
        }
    }
    
    func filterView(valueWillChangeAtFilterWithName name: FilterViewController.FilterName, value: AnyObject) {
        switch name {
        case .Deals:
            filteredDiners.deals = value as! Bool
            break
            
        case .Distance:
            filteredDiners.distance = value as! Float
            break
            
        case .Sort:
            filteredDiners.sort = value as! Int
            break
        }
    }
    
    
    func filterView(viewWillDismiss done: Bool) {
        if done {
            diners = filteredDiners
            dinerView.reloadData()
            getDiners(){}
        }
    }
}