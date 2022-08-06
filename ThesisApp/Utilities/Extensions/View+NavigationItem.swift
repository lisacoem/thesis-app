//
//  View+NavigationItem.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 09.07.22.
//

import SwiftUI

extension View {
    
    func navigationItem(_ name: String) -> some View {
        self
            .navigationBarHidden(true)
            .navigationBarTitle(Text(name))
            .edgesIgnoringSafeArea(.all)
    }
    
    func navigationLink() -> some View {
        self
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: ButtonBack())
    }
}
