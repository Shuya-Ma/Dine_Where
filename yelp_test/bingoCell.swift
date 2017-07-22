//
//  bingoCell.swift
//  yelp_test
//
//  Created by Kevin Lin on 12/7/16.
//  Copyright © 2016 Kevin Lin. All rights reserved.
//

import UIKit
import AlamofireImage

class bingoCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var restaurantCheck: UIImageView!
    
    var diner: Diner?
    var diners = dinerCollection()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Colors.canvas
    }
    
    func renewData() {
        nameLabel.text = diner?.name
        restaurantCheck.image = UIImage(named: "check_white")
    }
}


