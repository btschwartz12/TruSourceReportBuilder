//
//  LinkHelpController.swift
//  TruSourceReportBuilder
//
//  Created by Ben Schwartz on 5/10/20.
//  Copyright © 2020 Ben Schwartz. All rights reserved.
//

import Cocoa

//need to find a way to make the images show up


class LinkHelpController: NSViewController {
    
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var stepLabel: NSTextField!
    @IBOutlet weak var titleMessage: NSTextField!
    let images : [String] = ["step1", "step2", "step3", "step4", "step5", "step6.png"]
    let labels : [String] = [
        "Step 1: With your Gogle Sheet open, select 'File'",
        "Step 2: Scroll down and select 'Publish to the web'",
        "Step 3: Select 'Publish'",
        "Step 4: Close out of the window (do not use this link)",
        "Step 5: Copy and use the link of the original Google Sheet open",
        "To unpublish, go to the same menu and select 'Stop publishing'"
    ]
    var index : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.imageFrameStyle = .photo
        imageView.imageScaling = .scaleAxesIndependently

        updateScreen()
        // Do view setup here.
    }
    @IBAction func prevTouched(_ sender: Any) {
        index = index == 0 ? 5 : index - 1
        updateScreen()
    }
    @IBAction func nextTouched(_ sender: Any) {
        index = index == 5 ? 0 : index + 1
        updateScreen()
    }
    
    func updateScreen() {
        titleMessage.stringValue = index == 5 ? "How to unpublish your sheet (for after)" : "How to publish your sheet online"
        if let image = NSImage(named: images[index]) {
            imageView.image = image
        }
        else {
            print("error creating image")
        }
        stepLabel.stringValue = labels[index]
    }
    
}
