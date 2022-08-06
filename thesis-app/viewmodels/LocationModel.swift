//
//  LocationModel.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 06.08.22.
//

import CoreLocation

struct LocationModel: Identifiable {
    
    var id: UUID
    var coordinate: CLLocationCoordinate2D
    var timestamp: Date
    
    init(_ coordinate: CLLocationCoordinate2D) {
        self.id = UUID()
        self.timestamp = Date.now
        self.coordinate = coordinate
    }
}
