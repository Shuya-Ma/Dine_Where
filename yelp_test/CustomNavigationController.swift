//
//  NavigationController.swift
//  yelp_test
//
//  Created by Kevin Lin on 12/5/16.
//  Copyright © 2016 Kevin Lin. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        navigationBar.barTintColor = Colors.primary
        navigationBar.barStyle = .Black
        navigationBar.tintColor = UIColor.whiteColor()
    }
}

