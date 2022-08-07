//
//  FormModel.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 06.08.22.
//

import Foundation

protocol FormModel: ObservableObject {
    
    var errorMessage: String? { get set }
    
    func submit()
    func reset()
}
