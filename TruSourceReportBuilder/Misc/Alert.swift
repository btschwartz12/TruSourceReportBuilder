//
//  Alert.swift
//  TruSourceReportBuilder
//
//  Created by Ben Schwartz on 6/19/20.
//  Copyright © 2020 Ben Schwartz. All rights reserved.
//

import Foundation
import Cocoa

struct Alert {
    var title : String
    var msg : String
    
    static func showAlert(for vc: NSViewController, withTitle title: String, andMessage message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.beginSheetModal(for: vc.view.window!) { response in }
    }
    func show(for vc: NSViewController) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = msg
        alert.beginSheetModal(for: vc.view.window!) { response in }
    }
}



