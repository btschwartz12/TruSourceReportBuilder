//
//  ReportDescriptionManager.swift
//  TruSourceReportBuilder
//
//  Created by Ben Schwartz on 5/27/20.
//  Copyright © 2020 Ben Schwartz. All rights reserved.
//

import Foundation
import Cocoa

struct ReportDescriptionManager {
    
    var selectedType: ReportType
    var inputImage: NSImage
    var inputDescription: String
    var outputImage: NSImage
    var outputDescription: String
    
    init(with selectedType: ReportType) {
        switch selectedType {
        case .v0_7:
            self.selectedType = selectedType
            if let inputImg = NSImage(named: "v0.7_input") {
                inputImage = inputImg
            }
            else {
                print("failed to create input image")
                inputImage = NSImage()
            }
            if let outputImg = NSImage(named: "v0.7_output") {
                outputImage = outputImg
            }
            else {
                print("failed to create output image")
                outputImage = NSImage()
            }
            inputDescription = "- have google sheet data with column titles similar to the ones above. \n- parameters that will be used : Date_Posted, Unique_Identifier, State, Lead Price Total"
            outputDescription = "- report will include (# of leads) and (revenue per lead) for each state. \n- excludes leads with unique identifier GGenWE & Time of day after 7:30PM CST (19:30)\n- report will be formatted as json data that you will import to a google sheet"
            
        default:
            print("error: invalid report type selected")
            self.selectedType = .none
            self.inputImage = NSImage()
            self.outputImage = NSImage()
            self.inputDescription = ""
            self.outputDescription = ""
        }
    }
}
