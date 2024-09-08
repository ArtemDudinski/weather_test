import Foundation
import Alamofire

class WeatherService {
    
    static let shared = WeatherService()
    
    private init() {  }
    
    private let apiKey = "144f728583444a18a5e130333240809"
    
    func getCurrentWeather(lat: Double, lon: Double, completion: @escaping ((Result<WeatherData, Error>)->())) {
        guard NetworkMonitor.shared.isConnected else {
            
            if let cachedObject: WeatherData = CacheService.shared.getObject(for: .weatherKey) {
                completion(.success(cachedObject))
            } else {
                completion(.failure(NSError(domain: "Проверьте интернет!", code: 1)))
            }
            
            return
        }
               
        let url = "http://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(lat),\(lon)&aqi=no"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let responseModel = try JSONDecoder().decode(WeatherData.self, from: data)
                    completion(.success(responseModel))
                    CacheService.shared.saveObjects(object: responseModel, key: .weatherKey)
                } catch {
                    print("\(error)")
                    completion(.failure(NSError(domain: error.localizedDescription, code: 1)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getForecast(lat: Double, lon: Double, completion: @escaping ((Result<WeatherData, Error>)->())) {
        guard NetworkMonitor.shared.isConnected else {
            
            if let cachedObject: WeatherData = CacheService.shared.getObject(for: .forecastKey) {
                completion(.success(cachedObject))
            } else {
                completion(.failure(NSError(domain: "Проверьте интернет!", code: 1)))
            }
            
            return
        }
                
        let url = "http://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(lat),\(lon)&days=\(7)&aqi=no&alerts=no"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let responseModel = try JSONDecoder().decode(WeatherData.self, from: data)
                    completion(.success(responseModel))
                    CacheService.shared.saveObjects(object: responseModel, key: .forecastKey)
                } catch {
                    completion(.failure(NSError(domain: error.localizedDescription, code: 1)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
