//
//  FilterController.swift
//  TruSourceReportBuilder
//
//  Created by Ben Schwartz on 6/15/20.
//  Copyright © 2020 Ben Schwartz. All rights reserved.
//

import Cocoa

//just have it pass in which trait is going to be filtered

//have maybe a drop down for which filter and then a drop down for what to do with it then either a drop down or text field or date picker for what it should specifically be

//also have filter be dependant on which sheet they are filtering before asking for filter (if they need more than 1 url)

//make sure to catch contradicting filters

//also maybe ask if they want the filters to be || or &&

class FilterController: NSViewController {

    //outlets
    @IBOutlet weak var filterCategoryButton: NSPopUpButton!
    @IBOutlet weak var filterDirectionButton: NSPopUpButton!
    @IBOutlet weak var filterBodyButton: NSPopUpButton!
    @IBOutlet weak var datePicker: NSDatePicker!
    @IBOutlet weak var filterBodyField: NSTextField!
    @IBOutlet weak var filterNameTextField: NSTextField!
    @IBOutlet weak var filterMessage: NSTextField!
    @IBOutlet weak var checkBox: NSButton!
    
    //filter vars
    var presentingFilter : (Filter, IndexPath)? // if there is a filter being edited, nil if new filter
    var dateSelected : NSDate?
    var categorySelected : FilterType = .none
    var directionSelected : FilterDirection = .none
    var hasCustomName : Bool = false // do I need this?
    var customName: String? { // if filter has custom name
        get {
            if filterNameTextField.stringValue == "" {
                return nil
            }
            else {
                return filterNameTextField.stringValue
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        // Do view setup here.
    }
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 36 {
            doneTouched(NSLayoutConstraint())
        }
    
    }
}
extension FilterController {
    
    func initialize() {
        loadInFilter(withFilter: presentingFilter)
        setNameField()
        setCategoryButton()
        setDateButton(withDate: presentingFilter?.0.date)
        setBodyButton(withTitle: presentingFilter?.0.body)
    }
    
    //filter is either loaded in previously or being created new
    func loadInFilter(withFilter filterDouble: (Filter, IndexPath)?) {
        if let filterDouble = filterDouble {
            categorySelected = filterDouble.0.type
            directionSelected = filterDouble.0.direction
            if let name = filterDouble.0.name {
                checkBox.state = .on
                hasCustomName = true
                filterNameTextField.stringValue = name
            }
        }
        setFields(forFilter: filterDouble?.0)
    }
}
//MARK: events
private extension FilterController {
    
    @IBAction func catagoryTouched(_ sender: Any) {
        let selectedStr = filterCategoryButton.titleOfSelectedItem!
        if let type = FilterType(rawValue: selectedStr) {
            categorySelected = type
            setFields(forFilter: nil)
        }
        else { print("error (2192863)") }
    }
    @IBAction func directionTouched(_ sender: Any) {
        if let selectedDir = filterDirectionButton.titleOfSelectedItem {
            directionSelected = FilterDirection(rawValue: selectedDir)!
        }
        else {
            print("error (1263)")
        }
    }
    @IBAction func timeTouched(_ sender: Any) {
        let time = String(describing: datePicker.dateValue)
        print("time = \(time)")
    }
    @IBAction func checkBoxTouched(_ sender: Any) {
        hasCustomName = checkBox.state == .on
        setNameField()
    }
    @IBAction func doneTouched(_ sender: Any) {
        let vc = self.presentingViewController as! ShowsFilter
        var manager = FilterManager(with: vc.filters)
        manager.filterController = self
        manager.makeFilter(withController: self, withCategory: categorySelected, andDirection: directionSelected) { filter, alert in
            if let filter = filter {
                if let (_, index) = presentingFilter {
                    vc.filters[index.item] = filter
                    presentingFilter = nil
                    vc.presentingFilter = nil
                }
                else {
                    vc.filters.append(filter)
                }
                vc.collectionView.reloadData()
                dismiss(self)
            }
            else {
                if let alert = alert {
                    alert.show(for: self)
                }
                else {
                    Alert.showAlert(for: self, withTitle: "Error creating filter", andMessage: "Please check all filter properties and try again.")
                }
            }
        }
    }
}
//MARK: graphics
private extension FilterController {
    
    func setFields(forFilter filter: Filter?) {
        hideBodies()
        setDirectionButton()
        setBodyButton(withTitle: nil)
        switch categorySelected {
        case .datePosted:
            datePicker.isHidden = false
            filterMessage.stringValue = "Please select a date that your leads must be before/after"
        case .subsidyFlag:
            filterBodyButton.isHidden = false
            filterMessage.stringValue = "Please select a subsidy flag type for leads that won't be included"
        case .uniqueID:
            filterBodyField.isHidden = false
            filterMessage.stringValue = " uniqueID of lead (case sensitive)"
        case .source:
            filterBodyButton.isHidden = false
            filterMessage.stringValue = "Please select a source for leads to not include in report"
        case .QLE:
            filterBodyButton.isHidden = false
            filterMessage.stringValue = "Please select a QLE typr for leads to not include in report"
        case .none:
            filterMessage.stringValue = ""
        case .age:
            filterBodyField.isHidden = false
            filterMessage.stringValue = "Please type an age that leads for report should be younger/older than"
        case .householdSize:
            filterBodyField.isHidden = false
            filterMessage.stringValue = "Plese type a household size that leads for report should be above/below than"
        }
        if let filter = filter {
            directionSelected = filter.direction
            setDirectionButton()
            switch categorySelected {
            case .datePosted:
                datePicker.dateValue = filter.date!
            case .subsidyFlag:
                setBodyButton(withTitle: filter.body!)
            case .uniqueID:
                filterBodyField.stringValue = filter.body!
            case .source:
                setBodyButton(withTitle: filter.body!)
            case .QLE:
                setBodyButton(withTitle: filter.body!)
            case .age:
                filterBodyField.stringValue = filter.body!
            case .householdSize:
                filterBodyField.stringValue = filter.body!
            case .none:
                print("error (92384)")
            }
        }
    }
    
    func hideBodies() {
        filterBodyButton.isHidden = true
        datePicker.isHidden = true
        filterBodyField.isHidden = true
    }
    func setNameField() {
        filterNameTextField.isHidden = !hasCustomName
        if let name = customName {
            filterNameTextField.stringValue = name
        }
    }
    func setCategoryButton() {
        filterCategoryButton.removeAllItems()
        filterCategoryButton.addItems(withTitles: FilterType.allCases.map { $0.rawValue })
        filterCategoryButton.selectItem(withTitle: categorySelected.rawValue)
    }
    
    func setDirectionButton() {
        let directions = getDirections(forCategory: categorySelected)
        filterDirectionButton.removeAllItems()
        filterDirectionButton.addItems(withTitles: directions.map{ $0.rawValue })
        if directionSelected == .none {
            filterDirectionButton.selectItem(at: 0)
            directionSelected = directions[0]
        }
        else {
            if directions.contains(directionSelected) {
                 filterDirectionButton.selectItem(withTitle: directionSelected.rawValue)
            }
            else {
                filterDirectionButton.selectItem(at: 0)
                directionSelected = directions[0]
            }
        }
        
    }
    func setDateButton(withDate date: Date?) {
        datePicker.datePickerStyle = .textField
        if let date = date {
            datePicker.dateValue = date
        }
    }
    func setBodyButton(withTitle title: String?) {
        filterBodyButton.removeAllItems()
        switch categorySelected {
        case .subsidyFlag:
            filterBodyButton.addItems(withTitles: SubsidyFlagType.allCases.map { $0.rawValue })
        case .source:
            filterBodyButton.addItems(withTitles: SourceType.allCases.map { $0.rawValue })
        case .QLE:
            filterBodyButton.addItems(withTitles: QLEType.allCases.map { $0.rawValue })
        default:
            filterBodyButton.removeAllItems()
        }
        if let title = title {
            filterBodyButton.selectItem(withTitle: title)
        }
        else {
            filterBodyButton.selectItem(at: 0)
        }
    }
}
//MARK: misc
private extension FilterController {
    

}
