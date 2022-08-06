//
//  ViewRouter.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 09.07.22.
//

import SwiftUI

class ViewRouter: ObservableObject {
    
    static let shared = ViewRouter()
    
    @Published private(set) var currentView: Route
    @Published private(set) var lastView: Route
    
    private init() {
        currentView = Route.home
        lastView = Route.home
    }
    
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
        lastView = currentView
        currentView = route
    }
    
    func back() {
        currentView = lastView
    }
}

enum Route: CaseIterable {
    case home, activities, pinboard, account
    
    var index: Int {
        Route.allCases.firstIndex(of: self)!
    }
}
