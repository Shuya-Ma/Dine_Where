//
//  DinerTableView.swift
//  yelp_test
//
//  Created by Kevin Lin on 11/12/16.
//  Copyright © 2016 Kevin Lin. All rights reserved.
//

import UIKit

class DinerTableView: UITableView {
    
    let loadingMoreIndicator = UIActivityIndicatorView()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = Colors.canvas
        separatorStyle = .None
        
        rowHeight = UITableViewAutomaticDimension
        estimatedRowHeight = 100
        
        loadingMoreIndicator.frame = CGRectMake(0, 0, frame.width, 44)
        
        contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
        scrollIndicatorInsets = contentInset
    }
}
