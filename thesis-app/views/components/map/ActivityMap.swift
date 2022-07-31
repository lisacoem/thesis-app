//
//  ActivityMap.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 20.07.22.
//

import SwiftUI
import MapKit
import Map

struct ActivityMap: View {
    
    var activity: Activity
    @State var region: MKCoordinateRegion = MKCoordinateRegion()
    @State var mapRect = MKMapRect()
    
    init(_ activity: Activity) {
        self.activity = activity
    }
    
    var body: some View {
        Group {
            if let track = activity.track {
                
                Map(mapRect: $mapRect,
                    annotationItems: track,
                    annotationContent: { item in
                        ViewMapAnnotation(coordinate: item.coordinate) {
                            Circle()
                                .fill(colorOrange)
                                .frame(width: 5, height: 5)
                        }
                    },
                    overlays: [MKPolyline(coordinates: track.map(\.coordinate), count: track.count)],
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
                ).padding([.leading, .trailing], -spacingMedium)
            } else {
                Spacer()
            }
        }
        .frame(maxHeight: .infinity)
        .onAppear { updateRect() }
    }
    
    func updateRect() {
        if let points = activity.track?.map(\.coordinate).map(MKMapPoint.init) {
            mapRect = points.reduce(MKMapRect.null) { rect, point in
                let newRect = MKMapRect(origin: point, size: MKMapSize())
                return rect.union(newRect)
            }
        }
    }
}

struct ActivityMap_Previews: PreviewProvider {
    static var previews: some View {
        let persistenceController = PersistenceController.preview
        let activites: [Activity] = try! persistenceController.container.viewContext.fetch(Activity.fetchRequest())
        
        ActivityMap(activites.first!)
    }
}
