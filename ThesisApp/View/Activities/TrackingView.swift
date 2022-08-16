//
//  TrackingView.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 12.07.22.
//

import SwiftUI
import CoreMotion
import MapKit
import Combine


struct TrackingView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ViewModel
    
    init(
        trackingController: TrackingController,
        persistenceController: PersistenceController
    ) {
        self._viewModel = StateObject(wrappedValue:
            ViewModel(
                trackingController: trackingController,
                persistenceController: persistenceController
            )
        )
    }
    
    var body: some View {
        if let movement = viewModel.selectedMovement {
             if viewModel.trackingEnabled {
                 tracking(movement)
             } else {
                 requestPermission
             }
         } else {
             selectMovement
         }
    }
    
    var selectMovement: some View {
        Container {
            Text("Neue Aktivität")
                .modifier(FontTitle())
           
            VStack(spacing: Spacing.extraSmall) {
                ForEach(Movement.allCases, id: \.rawValue) { movement in
                    ButtonIcon(movement.name, icon: movement.symbol) {
                        viewModel.selectMovement(movement)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func tracking(_ movement: Movement) -> some View {
        Container {
            HStack {
                InfoItem(
                    symbol: movement.symbol,
                    value: "\(Formatter.double(viewModel.trackedDistance)) km"
                )
                
                Rectangle()
                    .frame(width: 1.5)
                
                Counter(startTime: viewModel.trackingStart)
            }.frame(maxHeight: 100)
            
            Map(
                viewModel.trackedRoute.map(\.coordinate),
                trackLocation: true
            ).padding([.leading, .trailing], -Spacing.medium)
               
            
            ButtonIcon("Aktivität beenden", icon: "checkmark") {
                viewModel.stopTracking()
                dismiss()
            }
        }
    }
    
    var requestPermission: some View {
        Container {
            PermissionError(
                symbol: "location.circle",
                description: "Um Kilometer sammeln zu können, musst du uns erlauben, auf deinen Standort zuzugreifen."
            )
        }
    }
}

struct TrackingView_Previews: PreviewProvider {
    static var previews: some View {
        TrackingView(
            trackingController: .init(),
            persistenceController: .preview
        )
    }
}
