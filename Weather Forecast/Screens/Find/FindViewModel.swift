import Foundation
import CoreLocation

class FindViewModel: BaseViewModel {
    
    let placemarks = Observable<[CLPlacemark]?>(nil)
    let connection = Observable<Bool?>(nil)
    
    var placemarksCount: Int {
        placemarks.value?.count ?? .zero
    }
    
    func checkConnection() {
        connection.value = networkMonitor.isConnected
    }
    
    func getPlacemarkTitle(from index: Int) -> String {
        guard let placemark = placemarks.value?[safe: index] else {
            return ""
        }
        
        return placemark.locality ?? placemark.name ?? ""
    }
    
    func findPlacemarks(for text: String) {
        if text.isEmpty {
            placemarks.value = []
        }
        
        locationService.getCoordinates(for: text, completion: { [weak self ] placemarks in
            self?.placemarks.value = placemarks
        })
    }
    
    func selectPlacemark(from index: Int) {
        guard let coordinate = placemarks.value?[safe: index]?.location?.coordinate else {
           return
        }
        
        locationService.selectLocationValue(coordinate)
    }
    
}
