//
//  OutputViewController.swift
//  TruSourceReportBuilder
//
//  Created by Ben Schwartz on 5/15/20.
//  Copyright © 2020 Ben Schwartz. All rights reserved.
//

import Cocoa

class OutputViewController: NSViewController {

    //debugging
    let format = true
    
    //crucial vars
    var items : [[String:Any]] = []
    var selectedType : ReportType = .none
    var data : Data?
    
    //outlets
    @IBOutlet weak var typeLabel: NSTextField!
    @IBOutlet weak var itemsLabel: NSTextField!
    @IBOutlet weak var createReportButton: NSButton!
    @IBOutlet weak var uploadButton: NSButton!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet var scrollTextView: NSTextView!
    @IBOutlet weak var buffer: NSProgressIndicator!
    @IBOutlet weak var dataLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        // Do view setup here.
    }
    
    func initialize() {
        resetScreen()
    }
    
    @IBAction func createReportTouched(_ sender: Any) {
        buffer.startAnimation(nil)
        let manager = ReportManager(with: items, reportType: selectedType)
        DispatchQueue.main.async {
            if let result = manager.createReport() {
                self.updateScreen(with: result)
                self.data = manager.reportDataJSON
            }
            else {
                print("error creating report")
                self.scrollTextView.string = "error creating report"
            }
        }
    }
}
//MARK: events
extension OutputViewController {
     
//    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
//        switch segue.identifier! {
//        case Segue.description.rawValue:
//            let reportController = segue.destinationController as! ReportDescriptionController
//            reportController.selectedType = selectedType
//        case Segue.upload.rawValue:
//            let uploadController = segue.destinationController as! APIUploadController
//            uploadController.data = data
//        default:
//            print("error: incorrect segue")
//        }
//    }
    
}
//MARK: graphics
private extension OutputViewController {
    
    func resetScreen() {
        guard check() else {
            dismiss(self)
            return
        }
        uploadButton.isHidden = true
        typeLabel.stringValue = "selected report : \(selectedType)"
        itemsLabel.stringValue = "items : \(items.count)"
        buffer.isDisplayedWhenStopped = false
    }
    
    func updateScreen(with items: [[String:Any]]) {
        buffer.stopAnimation(nil)
        uploadButton.isHidden = false
        createReportButton.isHidden = true
        scrollTextView.string = format ? getDictArrayText(from: items) : items.description
    }
    func updateScreen(with items: [String:Any]) {
        buffer.stopAnimation(nil)
        uploadButton.isHidden = false
        createReportButton.isHidden = true
        scrollTextView.string = format ? getDictText(from: items) : items.description
    }
}
//MARK: misc
private extension OutputViewController {
    
    func check() -> Bool {
        return items.count > 1 && selectedType != .none
    }
    func getDictArrayText(from dictArr: [[String:Any]]) -> String {
        var text = ""
        var count = 0
        for dict in dictArr {
            count += 1
            text += "\(count) : "

            if let revenueStr = dict["totalRevenue"] as? String, let revenue = Double(revenueStr),  let avgStr = dict["revenuePerLead"] as? String, let avg = Double(avgStr), let state = dict["state"] as? String, let count = dict["leadCount"] as? Int {
                text += "\(state) :  "
                text += "revenuePerLead=\(strFromDouble(avg)), "
                text += "leads=\(count), "
                text += "totalRevenue=\(strFromDouble(revenue))"
            }
            else {
                print("error reading dict")
            }
            text += "\n"
        }
        return text
    }
    func getDictText(from dict: [String:Any]) -> String {
        var text = ""
        var count = 0
        for (key, value) in dict {
            count += 1
            text += "\(count) : "
            text += key
            text += " : $"
            text += strFromDouble(value as! Double)
            text += "\n"
        }
        return text
    }
    func strFromDouble(_ double: Double) -> String {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 2
        let nsnum = double as NSNumber
        return nf.string(from: nsnum)!
    }
}
