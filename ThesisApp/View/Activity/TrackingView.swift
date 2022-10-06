//
//  TrackingView.swift
//  ThesisApp
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
           
            VStack(spacing: .small) {
                ForEach(Movement.allCases) { movement in
                    ButtonIcon(
                        movement.values().name,
                        icon: movement.values().symbol
                    ) {
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
                    symbol: movement.values().symbol,
                    value: "\(Formatter.double(viewModel.trackedDistance)) km"
                )
                
                Rectangle()
                    .frame(width: 1.5)
                
                Counter(startTime: viewModel.trackingStart)
            }
            .frame(maxHeight: 100)
            
            Map(
                viewModel.trackedRoute.map(\.coordinate),
                trackLocation: true
            )
            .spacing(.horizontal, .medium, negated: true)
               
            
            ButtonIcon("Aktivität beenden", icon: "checkmark") {
                viewModel.stopTracking()
                dismiss()
            }
        }
    }
    
    var requestPermission: some View {
        Container {
            Spacer()
            
            VStack(spacing: .medium) {
                Image(systemName: "location.circle")
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .foregroundColor(.customOrange)
                    .padding()
                
                ButtonIcon("Einstellungen öffnen", icon: "arrow.forward") {
                    UIApplication.shared.open(URL(string:
                        UIApplication.openSettingsURLString)!
                    )
                }
                
                Text("Um Kilometer sammeln zu können, musst du uns erlauben, auf deinen Standort zuzugreifen.")
                    .foregroundColor(.gray)
                    .modifier(FontText())
            }
            
            Spacer()
        }
    }
}

struct TrackingView_Previews: PreviewProvider {
    static var previews: some View {
        TrackingView(
            trackingController: .init(),
            persistenceController: .preview
        )
        .environment(
            \.managedObjectContext,
             PersistenceController.preview.container.viewContext
        )
    }
}
