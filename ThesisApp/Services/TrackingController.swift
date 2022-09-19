//
//  TrackingController.swift
//  ThesisApp
//
//  Created by Lisa Wittmann on 16.08.22.
//

import CoreLocation
import CoreData

class TrackingController: NSObject, ObservableObject {

    private var movement: Movement?
    
    @Published var tracking: Bool
    @Published var locating: Bool
    
    @Published var distance: Double
    @Published var locations: [CLLocation]

    private let locationManager: CLLocationManager
    
    override init() {
        self.tracking = false
        self.locating = false
        
        self.locations = .init()
        self.distance = 0
    
        self.locationManager = .init()
        super.init()
        
        self.initLocating()
    }
}
    
extension TrackingController {
    
    /// initialize tracking and start location updates
    /// - Parameter movement: movement for tracking
    func startTracking(for movement: Movement) {
        self.movement = movement
        self.tracking = true
        self.locations = []
        self.distance = 0
        
        if locationManager.authorizationStatus == .authorizedAlways {
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
    }
    
    /// stop tracking and location updates
    func stopTracking() {
        tracking = false
        locationManager.stopUpdatingLocation()
    }
}

extension TrackingController {
    
    /// initialize location manager and request permission for tracking if needed
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
    
    /// calculate distance in kilometers between start and end location and add it to tracked distance
    /// - Parameters:
    ///   - start: start location
    ///   - end: end location
    private func updateDistance(from start: CLLocation, to end: CLLocation) {
        let distanceInMeters = start.distance(from: end)
        if distanceInMeters <= locationManager.distanceFilter * 2 {
            self.distance += Converter.kilometers(meters: distanceInMeters)
        }
    }
}

extension TrackingController: CLLocationManagerDelegate {
    
    /// check if speed is valid for selected movement, update tracked distance and add locations to routes
    /// - Parameters:
    ///   - manager: core location location manager
    ///   - locations: last tracked locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard tracking else { return }
        
        guard let movement = movement,
              let speed = Converter.kilometersPerHour(metersPerSecond: locations.last?.speed),
              movement.isValid(speed: speed)
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
    
    /// start locating if tracking permission has been granted
    /// - Parameter manager: core location location manager
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
