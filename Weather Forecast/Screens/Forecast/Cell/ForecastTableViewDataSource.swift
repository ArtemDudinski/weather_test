import Foundation

enum ForecastTableViewDataSource {
    case firstCell(dateTitle: String, temperatureTitle: String)
    case valueCell(dateValue: String, temperatureValue: Double)
}

