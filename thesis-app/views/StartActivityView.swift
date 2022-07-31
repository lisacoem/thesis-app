//
//  StartActivityView.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 12.07.22.
//

import SwiftUI

struct StartActivityView: View {
    
    @State var movement: Movement?
    
    var body: some View {
        if let movement = movement {
            TrackingView(movement)
        } else {
            Page {
                Text("Neue Aktivität")
                    .modifier(FontTitle())
               
                VStack(spacing: spacingSmall) {
                    ForEach(Movement.allCases, id: \.name) { movement in
                        ButtonIcon(movement.name, icon: movement.icon, action: { select(movement) })
                    }
                }
            }
        }
    }
    
    private func select(_ movement: Movement) {
        self.movement = movement
    }
}

struct StartActivityView_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        
        StartActivityView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
