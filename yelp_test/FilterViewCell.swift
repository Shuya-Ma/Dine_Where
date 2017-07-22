//
//  FilterViewCell.swift
//  yelp_test
//
//  Created by Kevin Lin on 12/5/16.
//  Copyright © 2016 Kevin Lin. All rights reserved.
//

import UIKit

class FilterTableSwitchCell: UITableViewCell {
    
    @IBOutlet weak var switchCell: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    var filterName: FilterViewController.FilterName!
    var label: String? = nil
    var active: Bool = false
    
    var delegate: FilterTableSwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
        switchCell.textColor = Colors.text
        
        switchControl.addTarget(self, action: #selector(FilterTableSwitchCell.handleToggle(_:)), forControlEvents: .ValueChanged)
//        switchControl.onTintColor = Colors.primary
    }
    
    func renewData() {
        switchCell.text = label
        switchControl.on = active
    }
    
    func handleToggle(sender: UISwitch!) {
        delegate?.filterTableSwitchCell(activeDidChange: sender.on, filterName: filterName)
    }
}

class FilterTableRadioCell: UITableViewCell {
    
    @IBOutlet weak var radioLabel: UILabel!
    
    var label: String? = nil
    var active: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tintColor = Colors.primary
    }
    
    func renewData() {
        radioLabel.text = label
        accessoryType = active ? .Checkmark : .None
    }
}

class FilterTableDisplayCell: UITableViewCell {
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var caretImageView: UIImageView!
    
    var label: String? = nil
    var isExpanded: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        valueLabel.textColor = Colors.text
        caretImageView.alpha = 0.4
    }
    
    func renewData() {
        valueLabel.text = label
        caretImageView.transform = CGAffineTransformMakeRotation(isExpanded ? 0 : CGFloat(-M_PI_2))
    }
}

protocol FilterTableSwitchCellDelegate {
    func filterTableSwitchCell(activeDidChange active: Bool, filterName: FilterViewController.FilterName) -> Void
}