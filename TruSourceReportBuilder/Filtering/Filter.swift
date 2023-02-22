//
//  Filter.swift
//  TruSourceReportBuilder
//
//  Created by Ben Schwartz on 6/15/20.
//  Copyright © 2020 Ben Schwartz. All rights reserved.
//

import Foundation
import Cocoa

//have enum for what kind of thing is being filtered

//create struct that has that name and either if it should not be included, or should be in a certain range so can be passed to collection view object

//maybe have a filter be a closure and map the leads with the filter closure???

//check playground

//have a date selector for the date

//MARK: to be used in a later version
//protocol Filterable {
//    var name: String? { get set }
//    var description: String { get set }
//    var closure: (Lead) -> Bool { get set }
//    var type: FilterType { get }
//    var direction: FilterDirection { get }
//}
struct Filter {
    var name: String?
    var description: String
    var closure: (Lead) -> Bool
    var type: FilterType
    var direction: FilterDirection
    //depends on filter type
    var date: Date?
    var body: String?
}

//MARK: to be used in a later version
//struct FilterBundle : Filterable {
//    var name: String?
//    var description: String
//    var closure: (Lead) -> Bool
//    var type: FilterType
//    var direction: FilterDirection
//    var bodies : [String]
//}

enum FilterType : String, CaseIterable {
    case none
    case uniqueID
    case subsidyFlag
    case datePosted
    case source
    case QLE
    case age
    case householdSize //goes from 1-7
   // case phoneType //???? wtf is this
}
enum FilterDirection : String, CaseIterable {
    case none
    case before
    case after
    case above
    case below
    case only
    case omit
}

func getDirections(forCategory category: FilterType) -> [FilterDirection] {
    switch category {
    case .datePosted:
        return [.before, .after]
    case .uniqueID:
        return [.omit, .only]
    case .subsidyFlag:
        return [.omit, .only]
    case .source:
        return [.omit, .only]
    case .QLE:
        return [.omit, .only]
    case .age:
        return [.above, .below]
    case .householdSize:
        return [.above, .below]
    case .none:
        return [.none]
    }
}
//enums for leadfiltertypes
enum SubsidyFlagType : String, CaseIterable {
    case none
    case subsidy
    case noSubsidy
    case medicaid
}
enum SourceType : String, CaseIterable {
    case google
    case bing
    case MA
    case h1
}
enum QLEType : String, CaseIterable {
    case none
    case lost_coverage
    case had_or_adopted_a_child
    case recently_divorced
    case recently_married
    case recently_moved
    case lost_job
    case no
    case none_of_the_above
}

protocol ShowsFilter : NSViewController {
    func goToFilter(withFilter filter: Filter?, at index: IndexPath?)
    var filters : [Filter] { get set }
    var presentingFilter: (Filter, IndexPath)? { get set }
    var collectionView : NSCollectionView! { get }
}


