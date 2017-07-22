//
//  customTabBar.swift
//  yelp_test
//
//  Created by Kevin Lin on 12/7/16.
//  Copyright © 2016 Kevin Lin. All rights reserved.
//
import UIKit

class customTabBar: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableViewNav = ListNavigationController()
        tableViewNav.tabBarItem = UITabBarItem(title: "List", image: list, tag: 1)
        
    }
}
