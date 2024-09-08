import Foundation
import CoreLocation

class ForecastViewModel: BaseViewModel {
    
    let location = Observable<String?>(nil)
    let dataSource = Observable<[ForecastTableViewDataSource]?>(nil)
    
    private var weatherData: WeatherData? {
        didSet {
            configureLocationText()
            configureForecastTableViewDataSource()
        }
    }
    
    func getForecastDaysCount() -> Int {
        guard let forecast = weatherData?.forecast else {
            return .zero
        }
        
        return forecast.forecastday.count
    }
    
    func requestForecast() {
        locationService.locationValueForecast.bind { [weak self] value in
            guard let locationValue = value else {
                return
            }
            
            self?.getForecast(lat: locationValue.latitude,
                              lon: locationValue.longitude)
        }
    }
}

// MARK: - Private methods
private extension ForecastViewModel {
    func getForecast(lat: Double, lon: Double) {
        loading.value = true
        weatherService.getForecast(lat: lat,
                                         lon: lon,
                                         completion: { [weak self] result in
            defer {
                self?.loading.value = false
            }
            
            switch result {
            case .success(let result):
                self?.weatherData = result
            case .failure(let error):
                self?.updateCompletion = { self?.getForecast(lat: lat, lon: lon) }
                self?.error.value = error
            }
        })
    }
    
    func configureLocationText() {
        guard let weatherData else {
            return
        }
        
        location.value = weatherData.location.fullLocation
    }
    
    func configureForecastTableViewDataSource() {
        guard let forecast = weatherData?.forecast else {
            return
        }
        
        var data: [ForecastTableViewDataSource] = []
        
        data.append(.firstCell(dateTitle: "Дата", temperatureTitle: "Температура"))
        
        forecast.forecastday.forEach {
            data.append(.valueCell(dateValue: $0.date, temperatureValue: $0.day.avgtempC))
        }
        
        dataSource.value = data
    }
}
