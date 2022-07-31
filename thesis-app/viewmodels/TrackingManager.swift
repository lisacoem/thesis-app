//
//  TrackingManager.swift
//  thesis-app
//
//  Created by Lisa Wittmann on 22.07.22.
//

import SwiftUI
import CoreData
import CoreLocation
import CoreMotion
import MapKit

class TrackingManager: NSObject, ObservableObject {

    @Published var tracking: Bool
    @Published var locating: Bool
    
    @Published var region: MKCoordinateRegion
    @Published var distance: Float
    @Published var track: [TrackPointDto]
    
    @Published var startTime: Date
    @Published var duration: TimeInterval
    @Published var pace: Float
    
    private var movement: Movement?
    private var startLocation: CLLocation?
    
    private let activityManager: CMMotionActivityManager
    private let locationManager: CLLocationManager
    
    static var shared: TrackingManager = TrackingManager()
    
    private override init() {
        self.tracking = false
        self.locating = false
        
        self.activityManager = .init()
        self.locationManager = .init()
        
        self.region = .init()
        self.track = .init()
        self.distance = 0
        
        self.duration = Date().timeIntervalSince(Date.now)
        self.startTime = .init()
        self.pace = 0
    
        super.init()
        self.initLocating()
    }
    
    func startTracking(for movement: Movement) {
        self.movement = movement
        self.tracking = true
        self.track = []
        self.distance = 0
        self.duration = Date().timeIntervalSince(Date.now)
        self.startTime = Date.now
        
        if locationManager.authorizationStatus == .authorizedAlways {
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
        
        activityManager.startActivityUpdates(to: .main) { activity in
            guard let activity = activity else { return }
            self.updateTracking(for: activity)
        }
    }
    
    func stopTracking() {
        tracking = false
        activityManager.stopActivityUpdates()
        locationManager.stopUpdatingLocation()
        duration = Date().timeIntervalSince(startTime)
        startLocation = nil
    }
    
    private func updateTracking(for activity: CMMotionActivity) {
        self.tracking = (movement == .Walking && (activity.walking || activity.running)) ||
                        (movement == .Cycling && activity.cycling) || activity.stationary
    }
}


extension TrackingManager: CLLocationManagerDelegate {
    
    private func initLocating() {
        locationManager.delegate = self
        locationManager.distanceFilter = 50
        locationManager.activityType = .fitness
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = true
        
        if locationManager.authorizationStatus == .notDetermined {
            requestLocatingPermission()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard tracking else { return }
        
        track.append(contentsOf: locations.map {
            TrackPointDto(
                latitude: $0.coordinate.latitude,
                longitude: $0.coordinate.longitude,
                timeStamp: Date.now
            )
        })
        
        if startLocation == nil {
            startLocation = locations.first
        } else {
            if let lastLocation = locations.last {
                let distance = (startLocation?.distance(from: lastLocation) ?? 0) / 1000
                startLocation = lastLocation
                self.distance += Float(distance)
            }
        }
        
        locations.last.map {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.0025, longitudeDelta: 0.0025)
            )
        }
        
        objectWillChange.send()
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
    
    func requestLocatingPermission() {
        locationManager.requestAlwaysAuthorization()
    }
}

extension TrackingManager {
    
    func saveAsActivity(in context: NSManagedObjectContext) {
        if let movement = self.movement {
            let activity = Activity(movement: movement, distance: distance, date: startTime, duration: duration, in: context)
            activity.track = self.track.map { TrackPoint(from: $0, for: activity, in: context) }
            try? context.save()
        }
    }
}
