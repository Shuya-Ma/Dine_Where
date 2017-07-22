//
//  FilterViewController.swift
//  yelp_test
//
//  Created by Kevin Lin on 12/5/16.
//  Copyright © 2016 Kevin Lin. All rights reserved.
//

import UIKit
import Dollar

class FilterTableView: UITableView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = Colors.canvas
        rowHeight = 50
    }
}

class FilterViewController: UIViewController {
    @IBOutlet weak var filterTableView: FilterTableView!
    var filterSets: [FilterSet]!
    var delegate: FilterViewDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filter"
        filterSets = FilterViewController.defaultFilterSets
        filterTableView.dataSource = self
        filterTableView.delegate = self
    }
    
    @IBAction func handleSearchButton(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
        delegate.filterView(viewWillDismiss: true)
    }
}

extension FilterViewController {
    enum FilterName {
        case Deals
        case Distance
        case Sort
    }
    
    struct FilterItem {
        let name: FilterName
        let value: AnyObject
        let label: String?
    }
    
    class FilterSet {
        enum Type {
            case Switch
            case Radio(name: String)
        }
        
        let title: String?
        let type: Type
        let items: [FilterItem]
        let isExpandable: Bool
        var isExpanded: Bool
        let minNumberOfRows: Int
        var visibleRowCount: Int {
            get {
                switch type {
                case .Switch:
                    if(isExpandable) {
                        return isExpanded ? items.count : minNumberOfRows
                    }
                    return items.count
                case .Radio:
                    return isExpanded ? items.count : 0
                }
            }
        }
        
        init(title: String?, type: Type, items: [FilterItem], minNumberOfRows: Int, isExpandable: Bool = true, isExpanded: Bool = false) {
            self.title = title
            self.type = type
            self.items = items
            self.minNumberOfRows = minNumberOfRows
            self.isExpandable = isExpandable
            self.isExpanded = isExpanded
        }
        
        convenience init(title: String?, type: Type, items: [FilterItem], isExpandable: Bool = false, isExpanded: Bool = false) {
            self.init(title: title, type: type, items: items, minNumberOfRows: 3, isExpandable: false, isExpanded: isExpanded)
        }
    }
}

extension FilterViewController: UITableViewDataSource, UITableViewDelegate, FilterTableSwitchCellDelegate {
    
    static let defaultFilterSets: [FilterSet] = [
        FilterSet(
            title: "Deal",
            type: .Switch,
            items: [
                FilterItem(
                    name: .Deals,
                    value: YelpAccess.Filters.deal["value"] as! Bool,
                    label: YelpAccess.Filters.deal["label"] as? String
                )
            ]
        ),
        
        FilterSet(
            title: "Distance",
            type: .Radio(name: "distance"),
            items: YelpAccess.Filters.distances.map {datum in
                return FilterItem(
                    name: .Distance,
                    value: datum["value"] as! Float,
                    label: datum["label"] as? String
                )
            },
            isExpandable: true
        ),
        
        FilterSet(
            title: "Sort by",
            type: .Radio(name: "sort"),
            items: YelpAccess.Filters.sorts.map {datum in
                return FilterItem(
                    name: .Sort,
                    value: datum["value"] as! Int,
                    label: datum["label"] as? String
                )
            },
            isExpandable: true
        )
    ]
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filterSets.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filterSets[section].title
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filterSet = filterSets[section]
        
        switch filterSet.type {
        case .Switch:
            // If the filterSet is expandable, add 1 more row for Expand/Collapse button
            return filterSet.visibleRowCount + (filterSet.isExpandable ? 1 : 0)
            
        case .Radio:
            // The first row is to display value
            return (filterSet.isExpanded ? filterSet.items.count : 0) + 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let filterSet = filterSets[indexPath.section]
        
        switch filterSet.type {
        case .Switch:
            if indexPath.row == filterSet.visibleRowCount {
                return tableView.dequeueReusableCellWithIdentifier(filterSet.isExpanded ? "collapseCell" : "expandCell")!
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier("switchCell") as! FilterTableSwitchCell
            let filterItem = filterSet.items[indexPath.row]
            
            cell.filterName = filterItem.name
            cell.label = filterItem.label
            cell.active = delegate.filterView(isCellActiveForFilterWithName: filterItem.name, filterValue: filterItem.value)
            cell.delegate = self
            
            cell.renewData()
            return cell
            
        case .Radio( _):
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("displayCell") as! FilterTableDisplayCell
                
                cell.label = $.find(filterSet.items) { filterItem in
                    return filterItem.value.isEqual(self.delegate.filterView(valueForFilterWithName: filterItem.name))
                    }?.label
                cell.isExpanded = filterSet.isExpanded
                
                cell.renewData()
                return cell
            }
            
            let filterItem = filterSet.items[indexPath.row - 1]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("radioCell") as! FilterTableRadioCell
            
            cell.label = filterItem.label
            cell.active = delegate.filterView(isCellActiveForFilterWithName: filterItem.name, filterValue: filterItem.value)
            
            cell.renewData()
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let filterSet = filterSets[indexPath.section]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        func toggleExpanded() {
            filterSet.isExpanded = !filterSet.isExpanded
            tableView.reloadData()
        }
        
        var needAnimationRowIndexPaths: [NSIndexPath]!
        
        // Animation
        switch filterSet.type {
        case .Switch:
            if indexPath.row != filterSet.visibleRowCount {
                return
            }
            
            let start = filterSet.minNumberOfRows
            
            needAnimationRowIndexPaths = $.slice(filterSet.items, start: start).enumerate()
                .map { index, _ in
                    return NSIndexPath(forRow: index + start, inSection: indexPath.section)
            }
            break
            
        case .Radio( _):
            if indexPath.row != 0 {
                let filterItem = filterSet.items[indexPath.row - 1]
                delegate.filterView(valueWillChangeAtFilterWithName: filterItem.name, value: filterItem.value)
            }
            
            needAnimationRowIndexPaths = filterSet.items.enumerate().map { index, _ in
                return NSIndexPath(forRow: index + 1, inSection: indexPath.section)
            }
            
            break
        }
        
        
        if filterSet.isExpanded {
            tableView.reloadRowsAtIndexPaths(needAnimationRowIndexPaths, withRowAnimation: .Top)
            toggleExpanded()
            
        } else {
            toggleExpanded()
            tableView.reloadRowsAtIndexPaths(needAnimationRowIndexPaths, withRowAnimation: .Bottom)
        }
    }
    
    func filterTableSwitchCell(activeDidChange active: Bool, filterName: FilterViewController.FilterName) {
        delegate.filterView(valueWillChangeAtFilterWithName: filterName, value: active)
    }

}

protocol FilterViewDelegate {
    func filterView(isCellActiveForFilterWithName name: FilterViewController.FilterName, filterValue value: AnyObject) -> Bool
    func filterView(valueForFilterWithName name: FilterViewController.FilterName) -> AnyObject
    func filterView(valueWillChangeAtFilterWithName name: FilterViewController.FilterName, value: AnyObject) -> Void
    func filterView(viewWillDismiss done: Bool) -> Void
}
