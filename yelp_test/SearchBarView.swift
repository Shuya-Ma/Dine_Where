//
//  SearchBarView.swift
//  yelp_test
//
//  Created by Kevin Lin on 11/12/16.
//  Copyright © 2016 Kevin Lin. All rights reserved.
//

import UIKit

class SearchBarView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 2
    }
}
