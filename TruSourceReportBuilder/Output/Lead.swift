//
//  Lead.swift
//  TruSourceReportBuilder
//
//  Created by Ben Schwartz on 5/20/20.
//  Copyright © 2020 Ben Schwartz. All rights reserved.
//

import Foundation

//try using dateformatter
//also see if I can just straight up initialize like this

struct Lead {
 //   var leadType : LeadType
    var leadID: Int
    var datePosted : Date
    var uniqueID : String?
    var state : String
    var phone : Int
    var email : String
    var age : Int
    var qle : String?
    var subsidyFlag : String?
    var source : String?
    var householdSize : Int?
    var price : Double
    
}
enum LeadType : String, CaseIterable {
    case data
    case click
    case call
}
