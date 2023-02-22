//
//  ReportSelectionController.swift
//  TruSourceReportBuilder
//
//  Created by Ben Schwartz on 6/15/20.
//  Copyright © 2020 Ben Schwartz. All rights reserved.
//

import Cocoa
//https://www.appcoda.com/macos-programming-collection-view/

class ReportSelectionController: NSViewController, ShowsFilter {

    @IBOutlet weak var reportTypeButton: NSPopUpButton!
    @IBOutlet weak var currentFiltersScrollView: NSScrollView!
    
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var reportDescription: NSTextField!
    
    var selectedType : ReportType = .none
    var filters : [Filter] = []
    var presentingFilter: (Filter, IndexPath)?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        // Do view setup here.
    }
    
    
}
//MARK: key methods
extension ReportSelectionController {
   
    func initialize() {
        reportTypeButton.removeAllItems()
        reportTypeButton.addItems(withTitles: ReportType.allCases.map { $0.rawValue })
        reportTypeButton.selectItem(withTitle: selectedType.rawValue)
        
        setReportDescription()
        
        //guard let proto = collectionView.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: NSStoryboardSegue.Identifier, sender: Any?) -> Bool {
        switch identifier {
        case Segue.reportDescription.rawValue:
            setSelectedType()
            guard selectedType != .none else {
                return false
            }
        case Segue.filter.rawValue:
            setSelectedType()
            if selectedType == .none {
                Alert.showAlert(for: self, withTitle: "Please indicate a report type", andMessage: "")
                return false
            }
        default:
            print("error (12)")
        }
        return true
    }
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case Segue.reportDescription.rawValue:
            let descriptionController = segue.destinationController as? ReportDescriptionController
            descriptionController!.selectedType = selectedType
        case Segue.filter.rawValue:
            let dest = segue.destinationController as! FilterController
            dest.presentingFilter = presentingFilter
        default:
            print("error  (127)")
        }
    }
}
//MARK: events
extension ReportSelectionController {
    
    
    @IBAction func reportTypeTouched(_ sender: Any) {
        setSelectedType()
        setReportDescription()

    }
    @IBAction func finishTouched(_ sender: Any) {
        if selectedType == .none {
            Alert.showAlert(for: self, withTitle: "No report type selected", andMessage: "Please indicate a report type")
        }
        else {
            let mainController = self.presentingViewController as! MainController
            mainController.setReportInfo(withReportType: selectedType, andFilters: filters)
            dismiss(self)
        }
    }
    func goToFilter(withFilter filter: Filter?, at index: IndexPath?) {
        if let filter = filter, let index = index {
            presentingFilter = (filter, index)
            performSegue(withIdentifier: Segue.filter.rawValue, sender: nil)
            DispatchQueue.main.async {
                self.presentingFilter = nil
            }
            
        }
    }
    
}
//MARK: other
private extension ReportSelectionController {
    
    func setSelectedType() {
        if let identifier = reportTypeButton.titleOfSelectedItem {
            switch identifier {
            case "none":
                selectedType = .none
            case "v0_7":
                selectedType = .v0_7
            default:
                print("error (888)")
            }
        }
        else {
            selectedType = .none
        }
    }
    func setReportDescription() {
        switch reportTypeButton.titleOfSelectedItem {
        case "none":
            reportDescription.stringValue = "please indicate a report type"
        case "v0_7":
            reportDescription.stringValue = "report v. 0.7 description"
        default:
            print("error (1287)")
        }
            
            
    }
}
//MARK: collection view
extension ReportSelectionController: NSCollectionViewDataSource {

    static let labelItem = "FilterItem"
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let filter = filters[indexPath.item]
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FilterItem"), for: indexPath) as! FilterItem
        item.showingName = filter.name != nil ? true : false
        item.viewController = self
        item.setFilter(for: filter)
 //       item.filter = filter
        item.label.stringValue = filter.description
        item.setUpLabel()
        return item
    }
    
    
}

