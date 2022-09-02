//
//  TrackingController.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 16.08.22.
//

import CoreLocation
import CoreData

class TrackingController: NSObject, ObservableObject {

    @Published var tracking: Bool
    @Published var locating: Bool
    
    @Published var distance: Double
    @Published var locations: [CLLocation]
    
    @Published var startTime: Date
    
    private var movement: Movement?
    private let locationManager: CLLocationManager
    
    override init() {
        self.tracking = false
        self.locating = false
        
        self.locations = .init()
        self.distance = 0
        self.startTime = .init()
    
        self.locationManager = .init()
        super.init()
        
        self.initLocating()
    }
}
    
extension TrackingController {
    
    func startTracking(for movement: Movement) {
        self.movement = movement
        self.tracking = true
        self.locations = []
        self.distance = 0
        self.startTime = Date.now
        
        if locationManager.authorizationStatus == .authorizedAlways {
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
    }
    
    func stopTracking() {
        tracking = false
        locationManager.stopUpdatingLocation()
    }
}

extension TrackingController {
    
    private func initLocating() {
        locationManager.delegate = self
        locationManager.distanceFilter = 5
        locationManager.activityType = .fitness
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = true
        
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    private func updateDistance(from start: CLLocation, to end: CLLocation) {
        let distanceInMeters = start.distance(from: end)
        if distanceInMeters <= locationManager.distanceFilter * 2 {
            self.distance += Converter.kilometers(meters: distanceInMeters)
        }
    }
}

extension TrackingController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard tracking else { return }
        
        guard let movement = movement,
              let speed = Converter.kilometersPerHour(metersPerSecond: locations.last?.speed),
              speed >= movement.minSpeed && speed <= movement.maxSpeed
        else {
            return
        }
        
        if let start = self.locations.last, let end = locations.last {
            updateDistance(from: start, to: end)
        } else if let start = locations.first, let end = locations.last {
            updateDistance(from: start, to: end)
        }
        
        self.locations.append(contentsOf: locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                self.locating = true
                return
            default:
                self.locating = false
                locationManager.requestAlwaysAuthorization()
       }
    }
}
