//
//  ReportDescriptionController.swift
//  TruSourceReportBuilder
//
//  Created by Ben Schwartz on 5/23/20.
//  Copyright © 2020 Ben Schwartz. All rights reserved.
//

import Cocoa

class ReportDescriptionController: NSViewController {

    var selectedType : ReportType = .none
    @IBOutlet weak var selectedTypeLabel: NSTextField!
    @IBOutlet weak var inputImageView: NSImageView!
    @IBOutlet weak var inputLabel: NSTextField!
    @IBOutlet weak var outputImageView: NSImageView!
    @IBOutlet weak var outputLabel: NSTextField!
    
    //if need parent, self.presentingViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.window?.minSize = NSSize(width: 664, height: 392)
        
        initialize()
        // Do view setup here.
    }
    override func keyDown(with event: NSEvent) {
        dismiss(self)
    }
}
private extension ReportDescriptionController {
    
    func initialize() {
        let manager = ReportDescriptionManager(with: selectedType)
        selectedTypeLabel.stringValue = "selected report type : \(manager.selectedType.rawValue)"
        inputImageView.image = manager.inputImage
        inputLabel.stringValue = manager.inputDescription
        outputImageView.image = manager.outputImage
        outputLabel.stringValue = manager.outputDescription
    }
}
