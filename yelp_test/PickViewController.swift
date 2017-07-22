//
//  PickViewController.swift
//  yelp_test
//
//  Created by ZhuangYihan on 11/20/16.
//  Copyright © 2016 Kevin Lin. All rights reserved.
//

import Foundation
import UIKit

class PickViewController: UIViewController {
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var randomBtn: UIButton!
    @IBOutlet weak var myLabel1: UILabel!
    @IBOutlet weak var myLabel2: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var ratingStarView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var diners = dinerCollection()
    var filteredDiners: dinerCollection!
    let refreshControl = UIRefreshControl()
    
    var cardView: UIView!
    var back: UIImageView!
    var front: UIImageView!
    var showingBack = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.95, alpha: 1.00)
        print(diners.parameters)
        getDiners {}
        print(diners.count)
        front = UIImageView(image:UIImage(named:"flip-back"))
        front.layer.masksToBounds = false
        front.layer.cornerRadius = front.frame.height
        front.clipsToBounds = true
        
        let size:CGFloat = 250
        let screenWidth = self.view.frame.size.width
        let frame = CGRectMake((screenWidth/2)-(size/2), 120, size, size)
        let imageframe = CGRectMake(0, 0, size, size)
        
        back = UIImageView(image: UIImage(named:"flip-back"))
        back.frame = imageframe
        back.contentMode = .ScaleAspectFill
        
        front = UIImageView(image: UIImage(named: "flip-back"))
        front.frame = imageframe
        front.contentMode = .ScaleAspectFill
        
        cardView = UIView(frame: frame)
        cardView.layer.borderWidth = 1.0
        cardView.layer.masksToBounds = false
        cardView.layer.borderColor = UIColor.clearColor().CGColor
        cardView.layer.cornerRadius = size/2
        cardView.clipsToBounds = true
        
        cardView.addSubview(back)
        self.view.addSubview(cardView)
        cardView.addSubview(front)
        
        if (showingBack){
            myLabel2.hidden = false
        } else {
            myLabel2.hidden = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print(diners.count)
        nameLabel.textColor = Colors.text
        addressLabel.textColor = Colors.text
        distanceLabel.textColor = Colors.lightText
        reviewCountLabel.textColor = Colors.lightText
        ratingStarView.backgroundColor = UIColor.clearColor()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pickToFilterSegue" {
            filteredDiners = diners.filteringCopy()
            let filterViewController = segue.destinationViewController as! FilterViewController
            filterViewController.delegate = self
        }
    }
    
}

extension PickViewController {
    
    
    @IBAction func handleQueryChange(sender: UITextField) {
        diners = diners.filteringCopy()
        diners.term = sender.text!
        print("search/(sender.text)")
        view.endEditing(true)
        getDiners(){}
    }
    
    @IBAction func randomizePick(sender: AnyObject) {
        // randomize button tapped
        // first get image url
        let collectionSize = UInt32(diners.count)
        print("there are \(collectionSize) diners")
        let picker = Int(arc4random_uniform(collectionSize))
        var theDiner: Diner
        if picker <= diners.count && diners.count != 0 {
            theDiner = diners.items[picker]
            if let url = NSURL(string: theDiner.imageUrl!) {
                if let data = NSData(contentsOfURL: url) {
                    front.image = UIImage(data: data)
                }
            }
            myLabel1.text = theDiner.name
            renewData(theDiner)
        }
        
        
        // then add flip
        if(showingBack){
            print("flip from back to front")
            UIView.transitionFromView(back, toView: front, duration: 0.3, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            showingBack = false
            myLabel2.hidden = true
        } else {
            print("flip from front to back")
            UIView.transitionFromView(front, toView: back, duration: 0.2, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            print("flip again")
            UIView.transitionFromView(back, toView: front, duration: 0.3, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            
            myLabel2.hidden = true
        }
    }
    
}

extension PickViewController: FilterViewDelegate {
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
            //dinerView.renewData()
            getDiners(){}
        }
    }
    
    
}


extension PickViewController {
    func getDiners(done: () -> Void) {
        diners.fetch(
            done: { _ in
                done()
            },
            fail: {_ in}
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
    
    func renewData(diner:Diner){
        nameLabel.text = diner.name
        addressLabel.text = diner.address
        if let met = diner.distance {
            distanceLabel.text = String(format: "%.2f miles", arguments: [met/1609.344])
        }
        
        if let rating = diner.rating {
            ratingLabel.text = String(format: "%.1f", arguments: [rating])
        }
        
        if let reviewCount = diner.reviewCount {
            print(diner.reviewCount)
            print(reviewCount)
            let revCount = Int(reviewCount)
            reviewCountLabel.text = String("\(revCount) reviews")
        }
        
        ratingStarView.subviews.forEach { starView in
            starView.removeFromSuperview()
        }
        
        var rating: Float = 0
        
        if let r = diner.rating {
            rating = r
        }
        
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
}