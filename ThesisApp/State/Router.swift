//
//  Router.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 09.07.22.
//

import SwiftUI

class Router: ObservableObject {
    
    @Published private(set) var currentView: Route
    
    private init() {
        self.currentView = .home
    }
    
    static let shared = Router()
    
    func imageName(route: Route) -> String {
        switch route {
        case .home:
            return "house.fill"
        case .activities:
            return "bicycle"
        case .pinboard:
            return "pin.fill"
        case .account:
            return "person.fill"
        }
    }
    
    func navigate(to route: Route) {
        currentView = route
    }
    
}

enum Route: CaseIterable {
    case home, activities, pinboard, account
    
    var index: Int {
        Route.allCases.firstIndex(of: self)!
    }
}
