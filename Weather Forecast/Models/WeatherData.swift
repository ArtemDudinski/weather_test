import Foundation

struct WeatherData: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast?
}

struct Location: Codable {
    let name: String
    let region: String
    let country: String
    
    enum CodingKeys: String, CodingKey {
        case name, region, country
    }
    
    var fullLocation: String {
        "\(country), \(region), \(name)"
    }
}

struct Current: Codable {
    let tempC: Double
    let precipMm: Double
    let lastUpdated: String

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case precipMm = "precip_mm"
        case lastUpdated = "last_updated"
    }
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let date: String
    let day: ForecastDayModel
}

struct ForecastDayModel: Codable {
    let avgtempC: Double
    
    enum CodingKeys: String, CodingKey {
        case avgtempC = "avgtemp_c"
    }
}
