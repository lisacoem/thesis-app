//
//  Season.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 23.08.22.
//

import Foundation

enum Season: Int, CaseIterable {
    case january = 1,
         february = 2,
         march = 3,
         april = 4,
         may = 5,
         june = 6,
         july = 7,
         august = 8,
         september = 9,
         october = 10,
         november = 11,
         december = 12
    
    var month: Int { rawValue }
}
