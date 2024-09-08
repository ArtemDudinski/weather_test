import Foundation

class CacheService {
    
    static let shared = CacheService()
    
    enum Keys: String {
        case weatherKey = "kWeather"
        case forecastKey = "kForecast"
    }
    
    private init() {}
    
    private let storage = UserDefaults.standard
    
    func saveObjects<T: Codable>(object: T, key: Keys) {
        do {
            let key = key.rawValue
            let encodedData = try JSONEncoder().encode(object)
            storage.removeObject(forKey: key)
            storage.set(encodedData, forKey: key)
            storage.synchronize()
        } catch {
            print(error)
        }
    }
    
    func getObject<T: Codable>(for key: Keys) -> T? {
        let key = key.rawValue
        
        if let savedData = storage.object(forKey: key) as? Data {
            do {
                let object = try JSONDecoder().decode(T.self, from: savedData)
                return object
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}
