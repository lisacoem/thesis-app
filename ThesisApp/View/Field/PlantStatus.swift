//
//  PlantStatus.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 14.09.22.
//

import SwiftUI

struct PlantStatus: View {
    
    @ObservedObject var plant: Plant
    
    init(_ plant: Plant) {
        self.plant = plant
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: .small) {
    
            VStack(alignment: .leading, spacing: 2) {
                Text(plant.name)
                    .modifier(FontH5())
                Text("von \(plant.user.friendlyName)")
                    .modifier(FontLabel())
            }
            
            ProgressView(value: plant.growingTime, total: plant.growthPeriod)
            
            if !plant.isSeeded {
                Text("Du erhältst eine Benachrichtigung sobald dein Samen gepflanzt wurde")
                    .modifier(FontLabel())
            }
        }
        .frame(width: 150)
        .spacing(.all, .medium)
        .background(Color.background)
        .foregroundColor(.customBlack)
        .cornerRadius(12)
    }
}
