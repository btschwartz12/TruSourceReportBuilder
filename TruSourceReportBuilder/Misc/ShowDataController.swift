//
//  ShowDataController.swift
//  TruSourceReportBuilder
//
//  Created by Ben Schwartz on 6/15/20.
//  Copyright © 2020 Ben Schwartz. All rights reserved.
//

import Cocoa

class ShowInfoController: NSViewController {
    
    var titleText: String = "not set"
    var bodyText: String = "not set"

    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet var bodyTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()

        // Do view setup here.
    }
    
}
private extension ShowInfoController {
    
    func initialize() {
        titleLabel.stringValue = titleText
        bodyTextView.string = bodyText
        
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
        bodyTextView.isEditable = false
    }
}
