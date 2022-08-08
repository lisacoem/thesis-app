//
//  Map.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 07.08.22.
//

import SwiftUI
import MapKit
import CoreLocation

struct Map: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    var locations: [CLLocationCoordinate2D]
    var fitLocations: Bool
    var trackLocation: Bool
    
    init(
        _ locations: [CLLocationCoordinate2D],
        fitLocations: Bool = false,
        trackLocation: Bool = false
    ) {
        self.locations = locations
        self.fitLocations = fitLocations
        self.trackLocation = trackLocation
    }
    
    func makeCoordinator() -> Coordinator {
        Map.Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView(frame: .zero)
        view.delegate = context.coordinator
        
        if fitLocations {
            view.setVisibleMapRect(mapRect, animated: true)
        } else {
            view.setRegion(region, animated: true)
        }
        
        if trackLocation {
            view.showsUserLocation = true
            view.userTrackingMode = .follow
        }
        
        return view
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        if locations.isEmpty {
            view.removeOverlays(view.overlays)
            return
        }
        
        let polyline = MKPolyline(
            coordinates: locations,
            count: locations.count
        )
        
        view.addOverlay(polyline)
        
        if let renderer = view.renderer(for: polyline) as? MKPolylineRenderer {
            if (renderer.strokeColor != UIColor(colorOrange)) {
                renderer.strokeColor = UIColor(colorOrange)
            }
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var control: Map
        
        init(_ control: Map) {
            self.control = control
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let polylineRenderer = MKPolylineRenderer(overlay: polyline)
                polylineRenderer.strokeColor = UIColor(colorOrange)
                polylineRenderer.lineWidth = 4
                return polylineRenderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    var mapRect: MKMapRect {
        locations
            .map(MKMapPoint.init)
            .reduce(MKMapRect.null) { rect, point in
                let newRect = MKMapRect(origin: point, size: MKMapSize())
                return rect.union(newRect)
            }
    }
    
    var region: MKCoordinateRegion {
        if let location = locations.last {
            return .init(
                center: location,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.0025,
                    longitudeDelta: 0.0025
                )
            )
        }
        return .init()
    }
}

struct CustomMap_Previews: PreviewProvider {
    static var previews: some View {
        Map([])
            .environmentObject(TrackingManager.shared)
    }
}
