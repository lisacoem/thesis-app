//
//  TrackingMap.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 20.07.22.
//

import SwiftUI
import MapKit
import Map
import CoreLocation

struct TrackingMap: View {
    
    @EnvironmentObject var manager: TrackingManager
    
    var body: some View {
        Group {
            if manager.locating {
                mapView()
            } else {
                requestView()
            }
        }
        .frame(maxHeight: .infinity)
        .background(colorBackground)
    }
    
    @ViewBuilder
    private func mapView() -> some View {
        Map(coordinateRegion: $manager.region,
            annotationItems: manager.locations,
            annotationContent: { item in
                ViewMapAnnotation(coordinate: item.coordinate) {
                    Circle()
                        .fill(colorOrange)
                        .frame(width: 5, height: 5)
                }
            },
            overlays: [MKPolyline(coordinates: manager.locations.map(\.coordinate), count: manager.locations.count)],
            overlayContent: { overlay in
                RendererMapOverlay(overlay: overlay) { mapView, overlay in
                    guard let polyline = overlay as? MKPolyline else {
                        return MKOverlayRenderer(overlay: overlay)
                    }
                    let renderer = MKPolylineRenderer(polyline: polyline)
                    renderer.lineWidth = 4
                    renderer.strokeColor = UIColor(colorOrange)
                    return renderer
                }
            }
        )
        .padding([.leading, .trailing], -spacingMedium)
    }
    
    @ViewBuilder
    private func requestView() -> some View {
        VStack(spacing: 20) {
            Image(systemName: "location.circle")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(colorOrange)
                .padding()
            ButtonIcon("Tracking erlauben", icon: "location") {
                manager.requestLocatingPermission()
            }
            Text("Um deinen Fortschritt genauer verfolgen zu können, musst du uns erlauben, deinen Standort zu tracken.")
                .foregroundColor(.gray)
                .modifier(FontText())
        }
    }
}

struct TrackingMap_Previews: PreviewProvider {
    static var previews: some View {
        TrackingMap()
            .environmentObject(TrackingManager.shared)
    }
}
