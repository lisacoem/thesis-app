//
//  TestView.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 14.09.22.
//

import SwiftUI

struct TestItem: Identifiable {
    var id = UUID()
    var text: String
    var icon: String
}

struct TestView: View {
    
    @State var message = ""
    @State var items = [
        TestItem(text: "Lorem", icon: "arrow.down"),
        TestItem(text: "Ipsum", icon: "arrow.up")
    ]
    
    var body: some View {
        Container {
            Text("Buttontest").modifier(FontTitle())
            ButtonIcon("Button", icon: "plus") {
                message = "Button geklickt!"
            }
            
            Text(message)
                .foregroundColor(.customOrange)
                .modifier(FontHighlight())
            
            list
        }
    }
    
    var list: some View {
        VStack(spacing: .small) {
            ForEach(items) { item in
                HStack {
                    Text(item.text).modifier(FontText())
                    Spacer()
                    Image(systemName: item.icon)
                }
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
