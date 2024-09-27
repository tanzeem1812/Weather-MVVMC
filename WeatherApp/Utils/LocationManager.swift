import Foundation
import CoreLocation
import MapKit

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    
    private let locationManager: CLLocationManager = CLLocationManager()
    
    override init() {
        authorizationStatus = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}
