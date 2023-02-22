//
//  ReportManager.swift
//  TruSourceReportBuilder
//
//  Created by Ben Schwartz on 5/16/20.
//  Copyright © 2020 Ben Schwartz. All rights reserved.
//

import Foundation

class ReportManager {
    
    var items : [[String:Any]]
    var selectedType : ReportType
    let calendar = Calendar.current
    var reportData: [[String:Any]] = [[:]]
    var reportDataJSON: Data? {
        return try? JSONSerialization.data(withJSONObject: reportData, options: .prettyPrinted)
    }
    
    
    init(with items: [[String:Any]], reportType type: ReportType) {
        self.items = items
        self.selectedType = type
    }
    
    init(_ type: ReportType) {
        self.items = []
        self.selectedType = type
    }
    
    func createReport() -> [[String:Any]]? {
        guard check() else { return nil }
        let leads = getLeads()
        switch selectedType {
        case .v0_7:
            return v0_7(with: leads)
//        case .type2:
//            return type2(with: leads)
//        case .type3:
//            return type3(with: leads)
//        case .type4:
//            return type4(with: leads)
        case .none:
            print("error")
        }
        return nil
    }
}
//MARK: create reports
private extension ReportManager {
    
    func v0_7(with leads : [Lead]) -> [[String:Any]]? {
        
        var useableLeads: [Lead] = []
        
        //loop through leads, only select ones with report-specific conditions to be used for report
        for lead in leads {
            if lead.uniqueID != "GGenWE" && (calendar.component(.hour, from: lead.datePosted) < 19 || (calendar.component(.hour, from: lead.datePosted) == 19 && calendar.component(.minute, from: lead.datePosted) <= 30)) {
                useableLeads.append(lead)
            }
        }
        //go throught leads, counting up total lead revenue per state and leads per state
        var priceDict : [String:Double] = [:]
        var countDict : [String:Int] = [:]
        
        for lead in useableLeads {
            if let current = countDict[lead.state] {
                countDict[lead.state] = current + 1
            }
            else {
                countDict[lead.state] = 1
            }
            if let current = priceDict[lead.state] {
                priceDict[lead.state] = current + lead.price
            }
            else {
                priceDict[lead.state] = lead.price
            }
        }
        guard priceDict.count == countDict.count else {
            return nil
        }
        //what will be returned
        var reportDictArray : [[String:Any]] = [[:]]
        //loop through one of the dicts, and make a dict for each state
        for (key, price) in priceDict {
            var dict : [String:Any] = [:]
            dict["state"] = key
            dict["totalRevenue"] = String(describing: price)
            if let count = countDict[key] {
                dict["leadCount"] = count
                let avg = price / Double(count)
                let pAvg = getPreciseDouble(double: avg, with: 9329042)
                dict["revenuePerLead"] = String(describing: pAvg)
            }
            else {
                return nil
            }
            reportDictArray.append(dict)
        }
        reportDictArray.remove(at: 0)
        guard priceDict.count == reportDictArray.count else {
            return nil
        }
        //return array with dict for each state that includes total revenue, total leads, and average
        self.reportData = reportDictArray
        return reportDictArray
    }
    
//    func type2(with leads : [Lead]) -> [[String:Any]]? {
//        
//        return [[:]]
//    }
//    
//    func type3(with leads : [Lead]) -> [[String:Any]]? {
//        
//        return [[:]]
//    }
//    
//    func type4(with leads : [Lead]) -> [[String:Any]]? {
//        
//        return [[:]]
//    }
    
}
//MARK: get leads
private extension ReportManager {
    
    func getLeads() -> [Lead] {
        
        var leads : [Lead] = []
        //for dates
        let formatter = DateFormatter()
        let str = items[0]["dateposted"] as! String
        let arr = str.components(separatedBy: ":")
        if arr.count == 2 {
            formatter.dateFormat = "MM/dd/yy HH:mm"
        }
        else {
            formatter.dateFormat = "MM/dd/yy HH:mm:ss"
        }
        formatter.timeZone = NSTimeZone(name: "GMT") as TimeZone?
        
        //MARK: check the time zone again
        
        for dict in items {
            //loop through data, and do what needs to be done
            if let leadID = dict["leadid"] as? Int, let datePostedStr = dict["dateposted"] as? String, let state = dict["state"] as? String, let phone = dict["primaryphone"] as? Int, let email = dict["email"] as? String, let age = dict["age"] as? Int, let priceStr = (dict["leadpricetotal"] as? String) {
                //very messy
                let price = (String(priceStr[priceStr.index(priceStr.startIndex, offsetBy : 1)..<priceStr.endIndex]) as NSString).doubleValue
                let datePosted = formatter.date(from: datePostedStr)!
                let uniqueID = dict["uniqueidentifier"] as? String
                let qle = dict["qle"] as? String
                let subsidyFlag = dict["subsidyflag"] as? String
                
                let lead = Lead(leadID: leadID, datePosted: datePosted, uniqueID: uniqueID, state: state,  phone: phone, email: email, age: age, qle: qle, subsidyFlag: subsidyFlag, price: price)

                leads.append(lead)
            }
            else {
                print("error: data not found")
            }
        }
        return leads
    }
}
//MARK: misc
private extension ReportManager {
    
    func check() -> Bool {
        return items.count > 1 && selectedType != .none
    }
    func getPreciseDouble(double : Double, with: Int) -> Double {
        
        //fix this later
        return double
    }
    

}
