//
//  FilterManager.swift
//  TruSourceReportBuilder
//
//  Created by Ben Schwartz on 6/23/20.
//  Copyright © 2020 Ben Schwartz. All rights reserved.
//

import Foundation
import Cocoa

struct FilterManager {
    
    var filters: [Filter]
    var filterController : FilterController?
    var presentingController : ShowsFilter? {
        if let fc = filterController {
            return fc.presentingViewController as? ShowsFilter
        }
        else {
            return nil
        }
    }
    
    init(with filters: [Filter]) {
        self.filters = filters
    }
    func getFilterDict(withNewFilter filter: Filter, includeNewFilter include : Bool) -> [FilterType : [Filter]] {
        var arr = filters
        if include {
            arr.append(filter)
        }
        var dict : [FilterType : [Filter]] = [.uniqueID : [], .subsidyFlag : [], .age : [], .datePosted : [], .householdSize : [], .QLE : [], .source : []]
        for filter in arr {
            dict[filter.type]!.append(filter)
        }
        return dict
    }
    func getFiltersOfSameType(forFilter filter: Filter, includeNewFilter include : Bool) -> [Filter]? {
        return getFilterDict(withNewFilter: filter, includeNewFilter: include)[filter.type]
    }
    func makeFilter(withController vc: FilterController, withCategory categorySelected: FilterType, andDirection directionSelected: FilterDirection, completionHandler: (Filter?, Alert?) -> Void) {
        
        var filter: Filter?
        var alert : Alert?
        
        switch categorySelected {
        case .uniqueID:
            let uniqueID = vc.filterBodyField.stringValue
            switch directionSelected {
            case .omit:
                let closure: (Lead) -> Bool = { lead in
                    return lead.uniqueID != uniqueID
                }
                let description = uniqueID == "" ? "Exclude all leads with no uniqueID" : "Exclude all leads with uniqueID \"\(uniqueID)\""
                filter = Filter(description: description, closure: closure, type: .uniqueID, direction: .omit, date: nil, body: uniqueID)
            case .only:
                let closure: (Lead) -> Bool = { lead in
                    return lead.uniqueID == uniqueID
                }
                let description = uniqueID == "" ? "Include only leads with no uniqueID" : "Include only leads with uniqueID \"\(uniqueID)\""
                filter = Filter(description: description, closure: closure, type: .uniqueID, direction: .only, date: nil, body: uniqueID)
            default:
                print("error (2631)")
                filter = nil
                alert = Alert(title: "Error creating filter", msg: "2631")
                completionHandler(filter, alert)
                return
            }
        case .subsidyFlag:
            let subsidyFlag = vc.filterBodyButton.titleOfSelectedItem!
            switch directionSelected {
            case .omit:
                let closure: (Lead) -> Bool = { lead in
                    return lead.subsidyFlag != subsidyFlag
                }
                let description = subsidyFlag == "" ? "Exclude all leads with no subsidyFlag" : "Exclude all leads with subsidyFlag \"\(subsidyFlag)\""
                filter = Filter(description: description, closure: closure, type: .subsidyFlag, direction: .omit, date: nil, body: subsidyFlag)
            case .only:
                let closure: (Lead) -> Bool = { lead in
                    return lead.subsidyFlag == subsidyFlag
                }
                let description = subsidyFlag == "" ? "Include only leads with no subsidyFlag" : "Include only leads with subsidyFlag \"\(subsidyFlag)\""
                filter = Filter(description: description, closure: closure, type: .subsidyFlag, direction: .only, date: nil, body: subsidyFlag)
            default:
                print("error (29736)")
                filter = nil
                alert = Alert(title: "Error creating filter", msg: "29736")
                completionHandler(filter, alert)
                return
            }
        case .datePosted:
            let date = vc.datePicker.dateValue
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyyy HH:mm"
            switch directionSelected {
            case .before:
                let closure: (Lead) -> Bool = { lead in
                    return lead.datePosted.compare(date) == .orderedAscending
                }
                let description = "Exclude all leads after \(formatter.string(from: date))"
                filter = Filter(description: description, closure: closure, type: .datePosted, direction: .before, date: date, body: nil)
            case .after:
                let closure: (Lead) -> Bool = { lead in
                    return lead.datePosted.compare(date) == .orderedDescending
                }
                let description = "Exclude all leads before \(formatter.string(from: date))"
                filter =  Filter(description: description, closure: closure, type: .datePosted, direction: .after, date: date, body: nil)
            default:
                print("error (12389)")
                filter = nil
                alert = Alert(title: "Error creating filter", msg: "12389")
                completionHandler(filter, alert)
                return
            }
        case .source:
            let source = vc.filterBodyButton.titleOfSelectedItem!
            switch directionSelected {
            case .omit:
                let closure : (Lead) -> Bool = { lead in
                    return lead.source != source
                }
                let description = source == "" ? "Exclude all leads with no source" : "Exclude all leads with source \"\(source)\""
                filter =  Filter(description: description, closure: closure, type: .source, direction: .omit, date: nil, body: source)
            case .only:
                let closure : (Lead) -> Bool = { lead in
                    return lead.source == source
                }
                let description = source == "" ? "Include only leads with no source" : "Include only leads with source \"\(source)\""
                filter =  Filter(description: description, closure: closure, type: .source, direction: .only, date: nil, body: source)
            default:
                print("error (789)")
                filter = nil
                alert = Alert(title: "Error creating filter", msg: "789")
                completionHandler(filter, alert)
                return
            }
        case .QLE:
            let qle = vc.filterBodyButton.titleOfSelectedItem!
            switch directionSelected {
            case .omit:
                let closure : (Lead) -> Bool = { lead in
                    return lead.qle != qle
                }
                let description = qle == "" ? "Exclude all leads with no QLE" : "Exclude all leads with QLE \"\(qle)\""
                filter =  Filter(description: description, closure: closure, type: .QLE, direction: .omit, date: nil, body: qle)
            case .only:
                let closure : (Lead) -> Bool = { lead in
                    return lead.qle == qle
                }
                let description = qle == "" ? "Include only leads with no QLE" : "Include only leads with QLE \"\(qle)\""
                filter =  Filter(description: description, closure: closure, type: .QLE, direction: .only, date: nil, body: qle)
            default:
                print("error (09912)")
                filter = nil
                alert = Alert(title: "Error creating filter", msg: "09912")
                completionHandler(filter, alert)
                return
            }
        case .age:
            guard let age = Int(vc.filterBodyField.stringValue), age > 0 else {
                print("error (532)")
                filter = nil
                alert = Alert(title: "Error creating filter", msg: "532: please make sure a positive integer was entered")
                completionHandler(filter, alert)
                return
            }
            switch directionSelected {
            case .below:
                let closure : (Lead) -> Bool = { lead in
                    return lead.age <= age
                }
                let description = "Exclude all leads that are older than \(age)"
                filter = Filter(description: description, closure: closure, type: .age, direction: .below, date: nil, body: String(age))
            case .above:
                let closure : (Lead) -> Bool = { lead in
                    return lead.age >= age
                }
                let description = "Exclude all leads that are younger than \(age)"
                filter = Filter(description: description, closure: closure, type: .age, direction: .above, date: nil, body: String(age))
            default:
                print("error (1212121)")
                filter = nil
                alert = Alert(title: "Error creating filter", msg: "1212121")
                completionHandler(filter, alert)
                return
            }
        case .householdSize:
            guard let householdSize = Int(vc.filterBodyField.stringValue), householdSize > 0 else {
                print("error (54432)")
                filter = nil
                alert = Alert(title: "Error creating filter", msg: "54432: please make sure a positive integer is entered")
                completionHandler(filter, alert)
                return
            }
            switch directionSelected {
            case .below:
                let closure : (Lead) -> Bool = { lead in
                    return lead.householdSize ?? 0 <= householdSize
                }
                let description = "Exclude all leads that have a household size greater than \(householdSize)"
                filter = Filter(description: description, closure: closure, type: .householdSize, direction: .below, date: nil, body: String(householdSize))
            case .above:
                let closure : (Lead) -> Bool = { lead in
                    return lead.householdSize ?? 10 >= householdSize
                }
                let description = "Exclude all leads that have a household size less than \(householdSize)"
                filter = Filter(description: description, closure: closure, type: .householdSize, direction: .above, date: nil, body: String(householdSize))
            default:
                print("error (22441)")
                filter = nil
                alert = Alert(title: "Error creating filter", msg: "22441")
                completionHandler(filter, alert)
                return
            }
        case .none:
            print("error (090123)")
            filter = nil
            alert = Alert(title: "Error creating filter", msg: "090123")
            completionHandler(filter, alert)
            return
        }
        if let filter = filter {
            checkConflicts(forFilter: filter) { hasConflicts, alert in
                print("1")
                if hasConflicts {
                    if let alert = alert {
                        completionHandler(nil, alert)
                    }
                    else {
                        print("error (5231)")
                        completionHandler(nil, nil)
                        return
                    }
                }
                else {
                    if let alert = alert {
                        if !alert.title.contains("549") {
                            print("error (204102)")
                        }
                    }
                    else {
                        completionHandler(filter, nil)
                    }
                }
            }//do i need returns here around here
        }
        else {
            print("error (20123)")
            completionHandler(filter, alert)
            return
        }
    }
    //have it return an optional conflict message
    func checkConflicts(forFilter filter: Filter, completionHandler: (Bool, Alert?) -> Void) {
        
        var hasConflict : Bool = false
        var alert : Alert? = Alert(title: "Conflicted filter (549)", msg: "Please check filter properties and try again.")
        
        guard let allSimilarFilters = getFiltersOfSameType(forFilter: filter, includeNewFilter: true), let previousFilters = getFiltersOfSameType(forFilter: filter, includeNewFilter: false) else {
            completionHandler(false, nil)
            return
        }
        switch filter.type {
            case .uniqueID:
                let uidFilters = allSimilarFilters
                switch filter.direction {
                case .omit:
                    let dict = Dictionary(grouping: uidFilters, by: { $0.body! })
                    for (uid, filters) in dict {
                        if filters.count > 1 {
                            hasConflict = true
                            alert = Alert(title: "Conflicted filters", msg: "There is already a filter excluding leads with uniqueID \"\(uid)\"")
                            completionHandler(hasConflict, alert)
                            return
                        }
                    }
                case .only:
                    for uidFilter in uidFilters {
                        if uidFilter.direction == .omit {
                            hasConflict = true
                            alert = Alert(title: "Conflicted filters", msg: "There is a filter currently excluding leads with uniqueID \"\(uidFilter.body!)\", and is meaningless if this filter is applied. Please delete that filter or modify the current one before proceeding.")
                            completionHandler(hasConflict, alert)
                            return
                        }
                        if uidFilter.direction == .only {
                            //promptbundledfilter
                            hasConflict = true
                            alert = Alert(title: "Conflicted filters", msg: "Filter grouping (having an 'only' for multiple uniqueID filters) has not yet been implemented, but will be in a future version.")
                            completionHandler(hasConflict, alert)
                            return
                        }
                    }
                default:
                    print("error (0312)")
                }
                
            case .subsidyFlag:
                let subFlgFilters = allSimilarFilters
                switch filter.direction {
                case .omit:
                    let dict = Dictionary(grouping: subFlgFilters, by: { $0.body! })
                    for (subFlg, filters) in dict {
                        if filters.count > 1 {
                            hasConflict = true
                            alert = Alert(title: "Conflicted filters", msg: "There is already a filter excluding leads with subsidyFlag \"\(subFlg)\"")
                            completionHandler(hasConflict, alert)
                            return
                        }
                    }
                case .only:
                    for subFlgFilter in subFlgFilters {
                        if subFlgFilter.direction == .omit {
                            hasConflict = true
                            alert = Alert(title: "Conflicted filters", msg: "There is a filter currently excluding leads with subsidyFlag \"\(subFlgFilter.body!)\", and is meaningless if this filter is applied. Please delete that filter or modify the current one before proceeding.")
                            completionHandler(hasConflict, alert)
                            return
                        }
                        if subFlgFilter.direction == .only {
                            //promptbundledfilter
                            hasConflict = true
                            alert = Alert(title: "Conflicted filters", msg: "Filter grouping (having an 'only' for multiple subsidyFlag filters) has not yet been implemented, but will be in a future version.")
                            completionHandler(hasConflict, alert)
                            return
                        }
                    }
                default:
                    print("error (1230)")
                }
            case .datePosted:
                checkBoundedFilter(with: filter) { valid, alert in
                    if valid {
                        guard alert != nil else {
                            print("error (011234)")
                            return
                        }
                        hasConflict = false
                        completionHandler(hasConflict, nil)
                        return
                    }
                    else {
                        if let alert = alert, valid == false {
                            hasConflict = true
                            completionHandler(hasConflict, alert)
                            return
                        }
                        else {
                            print("error (011234)")
                            return
                        }
                    }
                }
            case .source:
                let srcFilters = allSimilarFilters
                switch filter.direction {
                case .omit:
                    let dict = Dictionary(grouping: srcFilters, by: { $0.body! })
                    for (src, filters) in dict {
                        if filters.count > 1 {
                            hasConflict = true
                            alert = Alert(title: "Conflicted filters", msg: "There is already a filter excluding leads with source \"\(src)\"")
                            completionHandler(hasConflict, alert)
                            return
                        }
                    }
                case .only:
                    for srcFilter in srcFilters {
                        if srcFilter.direction == .omit {
                            hasConflict = true
                            alert = Alert(title: "Conflicted filters", msg: "There is a filter currently excluding leads with source \"\(srcFilter.body!)\", and is meaningless if this filter is applied. Please delete that filter or modify the current one before proceeding.")
                            completionHandler(hasConflict, alert)
                            return
                        }
                        if srcFilter.direction == .only {
                            //promptbundledfilter
                            hasConflict = true
                            alert = Alert(title: "Conflicted filters", msg: "Filter grouping (having an 'only' for multiple source filters) has not yet been implemented, but will be in a future version.")
                            completionHandler(hasConflict, alert)
                            return
                        }
                    }
                default:
                    print("error (123320)")
                }
            case .QLE:
                let qleFilters = allSimilarFilters
                switch filter.direction {
                case .omit:
                    let dict = Dictionary(grouping: qleFilters, by: { $0.body! })
                    for (qle, filters) in dict {
                        if filters.count > 1 {
                            hasConflict = true
                            alert = Alert(title: "Conflicted filters", msg: "There is already a filter excluding leads with QLE \"\(qle)\"")
                            completionHandler(hasConflict, alert)
                            return
                        }
                    }
                case .only:
                    for qleFilter in qleFilters {
                        if qleFilter.direction == .omit {
                            hasConflict = true
                            alert = Alert(title: "Conflicted filters", msg: "There is a filter currently excluding leads with QLE \"\(qleFilter.body!)\", and is meaningless if this filter is applied. Please delete that filter or modify the current one before proceeding.")
                            completionHandler(hasConflict, alert)
                            return
                        }
                        if qleFilter.direction == .only {
                            //promptbundledfilter
                            hasConflict = true
                            alert = Alert(title: "Conflicted filters", msg: "Filter grouping (having an 'only' for multiple QLE filters) has not yet been implemented, but will be in a future version.")
                            completionHandler(hasConflict, alert)
                            return
                        }
                    }
                default:
                    print("error (123320)")
                }
            case .householdSize:
                checkBoundedFilter(with: filter) { valid, alert in
                    if valid {
                        guard alert != nil else {
                            print("error (011234)")
                            return
                        }
                        hasConflict = false
                        completionHandler(hasConflict, nil)
                        return
                    }
                    else {
                        if let alert = alert, valid == false {
                            hasConflict = true
                            completionHandler(hasConflict, alert)
                            return
                        }
                        else {
                            print("error (011234)")
                            return
                        }
                    }
                }
            case .age:
                checkBoundedFilter(with: filter) { valid, alert in
                    if valid {
                        guard alert != nil else {
                            print("error (011234)")
                            return
                        }
                        hasConflict = false
                        completionHandler(hasConflict, nil)
                        return
                    }
                    else {
                        if let alert = alert, valid == false {
                            hasConflict = true
                            completionHandler(hasConflict, alert)
                            return
                        }
                        else {
                            print("error (011234)")
                            return
                        }
                    }
                }
            case .none:
                print("error (01102)")
        }
        completionHandler(hasConflict, alert)
    }
    func checkBoundedFilter(with filter: Filter, completion: (Bool, Alert?) -> Void) {
        let filters = getFiltersOfSameType(forFilter: filter, includeNewFilter: false) ?? []
        if filters.count == 0 {
            completion(true, nil)
            return
        }
        if filters.count == 2 {
            completion(false, Alert(title: "Existing filters", msg: "Leads are already bounded by filters on each side. Please remove or edit other filters and try again."))
            return
        }
        if filters.count == 1 {
            switch filter.type {
            case .datePosted:
                let dateFilters = filters
                guard (filter.direction == .before || filter.direction == .after), filter.date != nil, let prev = dateFilters[0].date, let new = filter.date else {
                    completion(false, Alert(title: "Error creating filter", msg: "Please try again"))
                    return
                }
                if dateFilters[0].direction == .before {
                    if filter.direction == .before {
                        completion(false, Alert(title: "Conflicted filters", msg: "There is already a filter including leads only before a certain date. To create a new one, please delete or edit the previous one and try again."))
                        return
                    }
                    else {
                        if prev > new {
                            completion(true, nil)
                            return
                        }
                        else {
                            completion(false, Alert(title: "Conflicted filters", msg: "You've created an invalid date range for lead excluding. Please delete or edit the date filters and try again."))
                            return
                        }
                    }
                }
                else if dateFilters[0].direction == .after {
                    if filter.direction == .after {
                        completion(false, Alert(title: "Conflicted filters", msg: "There is already a filter including leads only after a certain date. To create a new one, please delete or edit the previous one and try again."))
                        return
                    }
                    else {
                        if prev < new {
                            completion(true, nil)
                            return
                        }
                        else {
                            completion(false, Alert(title: "Conflicted filters", msg: "You've created an invalid date range for lead excluding. Please delete or edit the date filters and try again."))
                            return
                        }
                    }
                }
            case .householdSize:
                let hFilters = filters
                guard (filter.direction == .above || filter.direction == .below), filter.body != nil, let prev = Int(hFilters[0].body!), let new = Int(hFilters[0].body!) else {
                    completion(false, Alert(title: "Error creating filter", msg: "Please try again"))
                    return
                }
                if hFilters[0].direction == .below {
                    if filter.direction == .below {
                        completion(false, Alert(title: "Conflicted filters", msg: "There is already a filter including leads only below a certain household size. To create a new one, please delete or edit the previous one and try again."))
                        return
                    }
                    else {
                        if prev > new {
                            completion(true, nil)
                            return
                        }
                        else {
                            completion(false, Alert(title: "Conflicted filters", msg: "You've created an invalid range for lead excluding. Please delete or edit the filters and try again."))
                            return
                        }
                    }
                }
                else if hFilters[0].direction == .above {
                    if filter.direction == .above {
                        completion(false, Alert(title: "Conflicted filters", msg: "There is already a filter including leads only above a certain household size. To create a new one, please delete or edit the previous one and try again."))
                        return
                    }
                    else {
                        if prev < new {
                            completion(true, nil)
                            return
                        }
                        else {
                            completion(false, Alert(title: "Conflicted filters", msg: "You've created an invalid range for lead excluding. Please delete or edit the date filters and try again."))
                            return
                        }
                    }
                }
            case .age:
                let ageFilters = filters
                guard (filter.direction == .above || filter.direction == .below), filter.body != nil, let prev = Int(ageFilters[0].body!), let new = Int(ageFilters[0].body!) else {
                    completion(false, Alert(title: "Error creating filter", msg: "Please try again"))
                    return
                }
                if ageFilters[0].direction == .below {
                    if filter.direction == .below {
                        completion(false, Alert(title: "Conflicted filters", msg: "There is already a filter including leads only below a certain age. To create a new one, please delete or edit the previous one and try again."))
                        return
                    }
                    else {
                        if prev > new {
                            completion(true, nil)
                            return
                        }
                        else {
                            completion(false, Alert(title: "Conflicted filters", msg: "You've created an invalid range for lead excluding. Please delete or edit the filters and try again."))
                            return
                        }
                    }
                }
                else if ageFilters[0].direction == .above {
                    if filter.direction == .above {
                        completion(false, Alert(title: "Conflicted filters", msg: "There is already a filter including leads only above a certain age. To create a new one, please delete or edit the previous one and try again."))
                        return
                    }
                    else {
                        if prev < new {
                            completion(true, nil)
                            return
                        }
                        else {
                            completion(false, Alert(title: "Conflicted filters", msg: "You've created an invalid range for lead excluding. Please delete or edit the date filters and try again."))
                            return
                        }
                    }
                }
            default:
                print("error (9210310)")
            }
        }
    }
}

//MARK: to be used in a later version
//func promptBundledFilter(forWindow window: NSWindow, name: String?, withType type: FilterType, direction dir: FilterDirection, currentBodies current: [String], newBody new: String) -> FilterBundle? {
//    var bundle: FilterBundle?
//    guard dir == .only else {
//        print("error (67281)")
//        return nil
//    }
//    var arr = current
//    arr.append(new)
//    let bodies : [String] = Array(_immutableCocoaArray: NSOrderedSet(array: arr))
//    let alert = NSAlert()
//    alert.messageText = "There is already a filter that includes leads only with uniqueID(s) {\(current.joined(separator: ", "))}. Would you like to group these and make a filter that includes leads with uniqueID's of either {\(current.joined(separator: ", "))} or \"\(new)\"?"
//    alert.addButton(withTitle: "Yes")
//    alert.addButton(withTitle: "No")
//    alert.alertStyle = .warning
//    alert.beginSheetModal(for: window) { response in
//        if response == NSApplication.ModalResponse.alertFirstButtonReturn {
//            switch type {
//            case .uniqueID:
//                let closure : (Lead) -> Bool = { lead in
//                    let arr = bodies
//                    return arr.contains(lead.uniqueID!)
//                }
//                let description = "Include only leads that have uniqueId's {\(bodies.joined(separator: ", "))}"
//                bundle = FilterBundle(name: name, description: description, closure: closure, type: type, direction: dir, bodies: bodies)
//            case .subsidyFlag:
//                let closure : (Lead) -> Bool = { lead in
//                    let arr = bodies
//                    return arr.contains(lead.subsidyFlag!)
//                }
//                let description = "Include only leads that have subsidyFlag's {\(bodies.joined(separator: ", "))}"
//                bundle = FilterBundle(name: name, description: description, closure: closure, type: type, direction: dir, bodies: bodies)
//            case .source:
//                let closure : (Lead) -> Bool = { lead in
//                    let arr = bodies
//                    return arr.contains(lead.source!)
//                }
//                let description = "Include only leads that have source's {\(bodies.joined(separator: ", "))}"
//                bundle = FilterBundle(name: name, description: description, closure: closure, type: type, direction: dir, bodies: bodies)
//            case .QLE:
//                let closure : (Lead) -> Bool = { lead in
//                    let arr = bodies
//                    return arr.contains(lead.qle!)
//                }
//                let description = "Include only leads that have QLE's {\(bodies.joined(separator: ", "))}"
//                bundle = FilterBundle(name: name, description: description, closure: closure, type: type, direction: dir, bodies: bodies)
//            case .datePosted:
//                print("error (10231)")
//            case .age:
//                print("error (10231)")
//            case .householdSize:
//                print("error (10231)")
//            case .none:
//                print("error (10231)")
//            }
//        }
//    }
//    return bundle
//}
