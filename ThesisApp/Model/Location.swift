//
//  Location.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 06.08.22.
//

import CoreLocation

struct Location: Identifiable {
    
    var id: UUID
    var coordinate: CLLocationCoordinate2D
    var timestamp: Date
    
    init(_ coordinate: CLLocationCoordinate2D, timestamp: Date) {
        self.id = UUID()
        self.timestamp = timestamp
        self.coordinate = coordinate
    }
}
