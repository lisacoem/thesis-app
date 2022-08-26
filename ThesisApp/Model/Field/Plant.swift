//
//  Plant.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 23.08.22.
//

import Foundation
import CoreData

@objc(Plant)
public class Plant: NSManagedObject {

    fileprivate(set) var name: String {
        get { name_! }
        set { name_ = newValue }
    }
    
    fileprivate(set) var plantingDate: Date {
        get { plantingDate_! }
        set { plantingDate_ = newValue.formatted ?? newValue }
    }
    
    fileprivate(set) var growthPeriod: TimeInterval {
        get { growthPeriod_ }
        set { growthPeriod_ = newValue.rounded(digits: 14) }
    }
    
    fileprivate(set) var user: User {
        get { user_! }
        set { user_ = newValue }
    }
}
