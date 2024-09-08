import Foundation
import CoreLocation

class LocationService: NSObject {
    
    static let shared = LocationService()
    
    let authorizationStatus = Observable<CLAuthorizationStatus?>(nil)
    let locationValue = Observable<CLLocationCoordinate2D?>(nil)
    let locationValueForecast = Observable<CLLocationCoordinate2D?>(nil)
    
    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocationCoordinate2D? {
        didSet {
            guard let currentLocation = currentLocation else {
                return
            }
            
            locationValue.value = currentLocation
            locationValueForecast.value = currentLocation
        }
    }
    
    private override init() {
        super.init()
        
        setupManager()
    }
    
    func getCoordinates(for city: String, completion: @escaping ([CLPlacemark]) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(city) { placemarks, _ in
            guard let placemarks else {
                return
            }
            
            completion(placemarks)
        }
    }
    
    func selectLocationValue(_ value: CLLocationCoordinate2D) {
        currentLocation = value
    }
    
    func updateLocation() {
        locationManager?.startUpdatingLocation()
    }
}

// MARK: - Private methods
private extension LocationService {
    func setupManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = manager.location?.coordinate
        manager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus.value = manager.authorizationStatus
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                manager.startUpdatingLocation()
            }
        }
    }
}
