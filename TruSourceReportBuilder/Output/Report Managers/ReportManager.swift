//
//  ReportManager.swift
//  TruSourceReportBuilder
//
//  Created by Ben Schwartz on 5/16/20.
//  Copyright © 2020 Ben Schwartz. All rights reserved.
//

import Foundation

//maybe have this as a protocal and see what methods all of them would have
//still will eventually have to make a struct for each different type of report.

struct ReportManager {
    
    var items : [[String:Any]]
    var selectedType : radio
    
    init(with items: [[String:Any]], reportType type: radio) {
        self.items = items
        self.selectedType = type
    }
    
    func createReport()
   
}
//make all reports
private extension ReportManager {
    
}
