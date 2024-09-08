import Foundation

class BaseViewModel {
    
    var locationService: LocationService {
        LocationService.shared
    }
    
    var weatherService: WeatherService {
        WeatherService.shared
    }
    
    var networkMonitor: NetworkMonitor {
        NetworkMonitor.shared
    }
    
    var updateCompletion: (()->())?
    let error = Observable<Error?>(nil)
    let loading = Observable<Bool?>(nil)
}
