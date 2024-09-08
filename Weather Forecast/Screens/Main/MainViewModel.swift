import Foundation
import CoreLocation

class MainViewModel: BaseViewModel {

    let authorizationStatus = Observable<CLAuthorizationStatus?>(nil)
    let locationText = Observable<String?>(nil)
    let temperature = Observable<Double?>(nil)
    let lastUpdate = Observable<String?>(nil)
    let commentText = Observable<String?>(nil)

    private var weatherData: WeatherData? {
        didSet {
            configureValues()
        }
    }
    
    func requestData() {
        locationService.authorizationStatus.bind { [weak self] value in
            self?.authorizationStatus.value = value
        }
        
        locationService.locationValue.bind { [weak self] value in
            guard let locationValue = value else {
                return
            }
            
            self?.getCurrentWeather(lat: locationValue.latitude,
                                    lon: locationValue.longitude)
        }
    }
    
    func refreshLocation() {
        locationService.updateLocation()
    }
}

// MARK: - Private methods
private extension MainViewModel {
    func getCurrentWeather(lat: Double, lon: Double) {
        loading.value = true
        weatherService.getCurrentWeather(lat: lat,
                                         lon: lon,
                                         completion: { [weak self] result in
            defer {
                self?.loading.value = false
            }
            
            switch result {
            case .success(let result):
                self?.weatherData = result
            case .failure(let error):
                self?.updateCompletion = { self?.getCurrentWeather(lat: lat, lon: lon) }
                self?.error.value = error
            }
        })
    }
    
    func configureComment(with value: WeatherData) {
        let precipMm = value.current.precipMm
        guard precipMm == 0 else {
            commentText.value = "Осадки \(precipMm) мм"
            return
        }

        let temperature = value.current.tempC
        
        switch temperature {
            case ..<0:
                commentText.value = "Температура меньше 0°C"
            case 0...15:
                commentText.value = "Температура от 0°C до 15°C"
            default:
                commentText.value = "Температура выше 15°C"
        }
    }
    
    func configureValues() {
        guard let value = weatherData else {
            return
        }
        
        
        locationText.value = value.location.fullLocation
        temperature.value = value.current.tempC
        lastUpdate.value = value.current.lastUpdated
        
        configureComment(with: value)
    }
}
