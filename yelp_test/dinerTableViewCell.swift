//
//  dinerTableViewCell.swift
//  yelp_test
//
//  Created by Kevin Lin on 11/12/16.
//  Copyright © 2016 Kevin Lin. All rights reserved.
//

import UIKit
import AlamofireImage

class dinerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var paperView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingStarView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var diner: Diner?
    var diners = dinerCollection()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization
        backgroundColor = Colors.canvas
        
        paperView.layer.shadowOffset = CGSize(width: 0, height: 1)
        paperView.layer.shadowOpacity = 0.25
        paperView.layer.shadowRadius = 2
        
        infoView.layoutMargins = Margins.large
        
        nameLabel.textColor = Colors.text
        addressLabel.textColor = Colors.text
        distanceLabel.textColor = Colors.lightText
        reviewCountLabel.textColor = Colors.lightText
        ratingStarView.backgroundColor = UIColor.clearColor()
        
        selectionStyle = .None
    }
    
    
    
    func renewData() {
        nameLabel.text = diner?.name
        addressLabel.text = diner?.address
        if let met = diner?.distance {
            distanceLabel.text = String(format: "%.2f miles", arguments: [met/1609.344])
        }
        
        if let rating = diner?.rating {
            ratingLabel.text = String(format: "%.1f", arguments: [rating])
        }
        
        if let reviewCount = diner?.reviewCount {
            print(diner?.reviewCount)
            print(reviewCount)
            let revCount = Int(reviewCount)
            reviewCountLabel.text = String("\(revCount) reviews")
        }
        
        if let imageURLString = diner?.imageUrl {
            previewImageView.clipsToBounds = true
            previewImageView.contentMode = .ScaleAspectFill
            previewImageView.af_setImageWithURL(NSURL(string: imageURLString)!, imageTransition: .CrossDissolve(0.2))
        }
        
        ratingStarView.subviews.forEach { starView in
            starView.removeFromSuperview()
        }
        
        var rating: Float = 0
        
        if let r = diner?.rating {
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
