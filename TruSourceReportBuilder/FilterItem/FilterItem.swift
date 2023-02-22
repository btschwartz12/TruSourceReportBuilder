//
//  FilterItem.swift
//  TruSourceReportBuilder
//
//  Created by Ben Schwartz on 6/20/20.
//  Copyright © 2020 Ben Schwartz. All rights reserved.
//

import Cocoa

class FilterItem: NSCollectionViewItem {

    //outletd
    @IBOutlet weak var label : NSTextField!
    @IBOutlet weak var infoButton: NSButton!
    //filter of the filteritem
    var filter: Filter?
    var showingName : Bool = true
    //the presenting controller that contains the collection view for filteritems
    var viewController: NSViewController?
    var reportController: ReportSelectionController? {
        if let vc = viewController as? ReportSelectionController {
            return vc
        }
        else {
            return nil
        }
    }
    var mainController: MainController? {
        if let vc = viewController as? MainController {
            return vc
        }
        else {
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        // Do view setup here.
    }
    func initialize() {
        label.cell?.truncatesLastVisibleLine = true
    }
    func setFilter(for filter: Filter) {
        self.filter = filter
        label.stringValue = filter.description
    }
}
//MARK: events
private extension FilterItem {
    //removing an item from the collectionview and updating
    @IBAction func removeTouched(_ sender: Any) {
        if let reportController = reportController, let collectionView = reportController.collectionView {
            if let index = collectionView.indexPath(for: self) {
                reportController.filters.remove(at: index.item)
                var set = Set<IndexPath>()
                set.insert(index)
                collectionView.deleteItems(at: set)
                collectionView.reloadData()
            } else { print("error (8934) ") }
        }
        else if let mainController = mainController, let collectionView = mainController.collectionView {
            if let index = collectionView.indexPath(for: self) {
                mainController.filters.remove(at: index.item)
                var set = Set<IndexPath>()
                set.insert(index)
                collectionView.deleteItems(at: set)
                collectionView.reloadData()
            } else { print("error (09128734) ") }
        }
        else { print("error (82342) ") }
    }
    //determines if the name or description is shown on the filteritem
    @IBAction func infoTouched(_ sender: Any) {
        let hasName = filter?.name != nil
        if hasName {
            showingName = !showingName
            setUpLabel()
        }
    }
    //goes to filter controller to edit the filter of the filteritem
    @IBAction func buttonTouched(_ sender: Any) {
        print("button touched")
        if let reportController = reportController {
            let index = reportController.collectionView.indexPath(for: self)
            reportController.goToFilter(withFilter: filter, at: index)
        }
        else if let mainController = mainController {
            let index = mainController.collectionView.indexPath(for: self)
            mainController.goToFilter(withFilter: filter, at: index)
        }
        else {
            print("error: view controller not initialized")
        }
    }
}
//MARK: graphics
extension FilterItem {
    //determines what image to show for the info buttom and what the label should say based on user input
    func setUpLabel() {
        infoButton.isHidden = false
        if showingName {
           if let name = filter?.name {
                label.stringValue = name
                infoButton.image = NSImage(imageLiteralResourceName: "NSTouchBarGetInfoTemplate")
           }
           else { print("error (908)") }
        }
        else {
            if let filter = filter, let _ = filter.name {
                label.stringValue = filter.description
            }
            else {
                infoButton.isHidden = true
            }
            infoButton.image = NSImage(imageLiteralResourceName: "NSUserGroup")
        }
    }
}
