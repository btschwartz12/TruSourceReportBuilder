//
//  APIUploadController.swift
//  TruSourceReportBuilder
//
//  Created by Ben Schwartz on 5/18/20.
//  Copyright © 2020 Ben Schwartz. All rights reserved.
//

import Cocoa
import Foundation

class APIUploadController: NSViewController {
    
    //instance vars
    var data : Data?
    var jsonString: String {
        if let data = data {
            return String(data: data, encoding: .utf8)!
        }
        else {
            return "error"
        }
    }
    var converterURL : String = "https://json-csv.com/"
    //outlets
    @IBOutlet weak var dataDescriptionLabel: NSTextField!
    @IBOutlet weak var copyStatusLabel: NSTextField!
    @IBOutlet weak var converterButton: NSButton!
    @IBOutlet weak var step2Label: NSTextField!
    @IBOutlet weak var step2DescriptionLabel: NSTextField!
    @IBOutlet weak var arrowImageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        initialize()
    }
    
    @IBAction func copyToClipboardTouched(_ sender: Any) {
        let clipboard = NSPasteboard.general
        clipboard.declareTypes([.string], owner: nil)
        if clipboard.setString(jsonString, forType: .string) {
            copyStatusLabel.stringValue = "successful"
            step2Label.stringValue = "Step 2: "
            step2Label.isHidden = false
            converterButton.isHidden = false
            step2DescriptionLabel.isHidden = false
            arrowImageView.isHidden = false
        }
        else {
            copyStatusLabel.stringValue = "unsuccessful, please exit"
        }
    }
    @IBAction func converterTouched(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: converterURL)!)
        converterButton.isHidden = true
        step2Label.stringValue = "Step 3: "
        step2DescriptionLabel.stringValue = "copy the outputted table, paste to google sheet, and rearrange the columns to desired order"
        arrowImageView.isHidden = true
        
    }
    
}
private extension APIUploadController {
    
    func initialize() {
        if let data = data {
            dataDescriptionLabel.stringValue = data.description
        }
        else {
            if let outputController = self.presentingViewController as? OutputViewController {
                outputController.scrollTextView.string = "error creating report : no data"
                dismiss(self)
            }
            else {
                print("big error")
            }
        }
        converterButton.isHidden = true
        step2Label.isHidden = true
        step2DescriptionLabel.isHidden = true
        arrowImageView.isHidden = true
        
        
    }
}

//https://json-csv.com/
//https://support.google.com/docs/answer/3093335?hl=en
